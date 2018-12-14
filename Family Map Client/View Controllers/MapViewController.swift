//
//  MapViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var store: MemoryStore?
    var lastLines: [MKOverlay] = []
    var allAnnotations: [MKAnnotation] = []

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var mainMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Family Map"
        mainMap.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if let store = store {  // TODO: use a `guard` clause

            self.updateMap()

            if store.people.count == 0 {

                let (ok, message) = store.refreshPeople()

                if !ok {
                    print("Problem updating list of people: \(message)")
                    doAlert("Error", message: "Problem fetching people: \(message)")
                }
                
                // refreshEvents() takes a callback that gets called
                // from the main thread once the call has finished
                // executing
                let (ok2, message2) = store.refreshEvents() {
                    (ok, resp) in
                    if ok { self.updateEvents() }
                }
                if !ok2 {
                    print("Problem updating list of events: \(message2)")
                    doAlert("Error", message: "Problem fetching events: \(message2)")
                }
            }
        }
        else {
            // no data store; go to login page
            self.performSegue(withIdentifier: "doAuth", sender: nil)
        }
    }

    @IBAction func doLogOut(_ sender: Any) {
        store?.nukeAuthToken()
        self.performSegue(withIdentifier: "doAuth", sender: nil)
    }

    func updateMap() {
        guard let store = store else {return}

        mainMap.mapType = store.getMapType()
        updateEvents()
    }
    
    func updateEvents() {
        guard let store = store else {return}

        mainMap.removeAnnotations(allAnnotations)

        for (_, event) in store.events {
            let marker = EventMarker.fromEvent(event, store: store)
            allAnnotations += [marker]
            mainMap.addAnnotation(marker)
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mainMap.setRegion(coordinateRegion, animated: true)
    }

    func doAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMap(unwindSeuge: UIStoryboardSegue) {
    }

    @IBAction func showEventDetail(sender: UIButton, forEvent event: UIEvent) {
        print("Showing event detail")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: PersonDetailController.self) {
            if let dest = segue.destination as? PersonDetailController,
               let location = sender as? EventMarker,
                let person = store!.people[location.personID] {
                dest.store = store
                dest.title = "\(person.firstName) \(person.lastName)"
                dest.currentPersonID = location.personID
            }
        }
        else if segue.destination.isKind(of: SettingsController.self) {
            if let dest = segue.destination as? SettingsController {
                dest.store = store
            }
        }
        else if segue.destination.isKind(of: FilterViewController.self) {
            if let dest = segue.destination as? FilterViewController {
                dest.store = store
            }
        }
        else if segue.destination.isKind(of: SearchViewController.self) {
            if let dest = segue.destination as? SearchViewController {
                dest.store = store
            }
        }
    }

    func drawLine(mapView: MKMapView, coordinates: [CLLocationCoordinate2D], title: String? = nil, subtitle: String? = nil) {
        var coords = coordinates
        let line = MKGeodesicPolyline(coordinates: &coords, count: coordinates.count)
        line.title = title
        line.subtitle = subtitle
        lastLines += [line]
        mapView.addOverlay(line)
    }
    func drawLifeLines(for personID: String, mapView: MKMapView) {
        guard let store = store else { return }
        if store.getShowLifeLine() {
            let events: [Event] = store.eventsForPerson(personID)
            let coordinates = events.map({ CLLocation(latitude: $0.latitude, longitude: $0.longitude).coordinate })
            drawLine(mapView: mapView, coordinates: coordinates, title: "lifeLine")
        }
    }
    func drawFamilyLines(for personID: String, mapView: MKMapView, generation: Int) {
        guard let store = store else { return }
        guard store.getShowFamilyLine() else { return }

        guard let parents = store.getParents(fromPerson: personID) else { return }
        let (father, mother) = parents
        let me = personID
        guard let my_birth: Event = store.getFirstEvent(me) else { return }

        if let father_birth = store.getFirstEvent(father) {
            let events: [Event] = [my_birth, father_birth]
            let coordinates = events.map({ CLLocation(latitude: $0.latitude, longitude: $0.longitude).coordinate })
            drawLine(mapView: mapView, coordinates: coordinates, title: "familyLine", subtitle: "\(generation)")
            drawFamilyLines(for: father, mapView: mapView, generation: generation + 1)
        }
        if let mother_birth = store.getFirstEvent(mother) {
            let events: [Event] = [my_birth, mother_birth]
            let coordinates = events.map({ CLLocation(latitude: $0.latitude, longitude: $0.longitude).coordinate })
            drawLine(mapView: mapView, coordinates: coordinates, title: "familyLine", subtitle: "\(generation)")
            drawFamilyLines(for: mother, mapView: mapView, generation: generation + 1)
        }
    }
    func drawSpouseLines(for personID: String, mapView: MKMapView) {
        guard let store = store else { return }
        if store.getShowSpouseLine() {
            if let spouseID = store.people[personID]?.spouse,
               let my_birth: Event = store.eventsForPerson(personID)[0],
               let spouse_birth: Event = store.eventsForPerson(spouseID)[0] {
                let events = [my_birth, spouse_birth]
                let coordinates = events.map({ CLLocation(latitude: $0.latitude, longitude: $0.longitude).coordinate })
                drawLine(mapView: mapView, coordinates: coordinates, title: "spouseLine")
            }
        }
    }
}

// Snarfed in part from https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let store = store else { return MKOverlayRenderer() }
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5

        switch polyline.title {
        case "lifeLine": renderer.strokeColor = store.getLifeLineColor()
        case "spouseLine": renderer.strokeColor = store.getSpouseLineColor()
        case "familyLine":
            renderer.strokeColor = store.getFamilyLineColor()
            let power = Int(polyline.subtitle ?? "0") ?? 0
            let denominator = Double(power == 0 ? 1 : 2 << power)
            renderer.lineWidth = CGFloat(3.0 * (1.0 / denominator))
        default: renderer.strokeColor = UIColor.blue
        }
        
        return renderer
    }

    // Gets called when I click a marker
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isKind(of: EventMarkerDetail.self) {
            let marker = view as! EventMarkerDetail
            let eventModel = marker.eventModel
            
            let personID = eventModel.personID
            drawLifeLines(for: personID, mapView: mapView)
            drawFamilyLines(for: personID, mapView: mapView, generation: 0)
            drawSpouseLines(for: personID, mapView: mapView)
        }
    }

    // this gets called when I click *off* a marker
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: EventMarkerDetail.self) {
            for line in lastLines {
                mapView.removeOverlay(line)
            }
            lastLines = []
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EventMarker,
              let store = store else { return nil }

        let identifier = "marker-\(annotation.eventID)"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
             as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = EventMarkerDetail(annotation: annotation, reuseIdentifier: identifier, eventModel: store.events[annotation.eventID]!)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let detailButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = detailButton
        }

        let person = store.people[annotation.personID]!
        view.leftCalloutAccessoryView = UIImageView(image: UIImage(named: person.gender == "m" ? "male_outline" : "female_outline"))

        view.markerTintColor = annotation.markerTintColor
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! EventMarker
        self.performSegue(withIdentifier: "showPerson", sender: location)
    }
}
