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
    var lastLine: MKOverlay?

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var mainMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Family Map"
        mainMap.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        print("map coming online...")
        if let store = store {
            print("we have a data store")
            if store.people.count == 0 {
                let (ok, message) = store.refreshPeople()
                if !ok {
                    print("Problem updating list of people: \(message)")
                    doAlert("Error", message: "Problem fetching people: \(message)")
                } else { print("refreshing people seems alright") }
                
                let (ok2, message2) = store.refreshEvents() {
                    (ok, resp) in
                    guard ok else {return}
                    
                    self.updateMap()
                }
                if !ok2 {
                    print("Problem updating list of events: \(message2)")
                    doAlert("Error", message: "Problem fetching events: \(message2)")
                } else { print("refreshing events seems alright") }
            }
        }
        else {
            print("we have no data store, need to go to auth")
            self.performSegue(withIdentifier: "doAuth", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    @IBAction func doLogOut(_ sender: Any) {
        store?.authToken = ""
        self.performSegue(withIdentifier: "doAuth", sender: nil)
    }
    
    func updateMap() {
        print("Updating map points...")
//            let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//            centerMapOnLocation(location: initialLocation)
        guard let store = store else {return}

        for (_, event) in store.events {
            let marker = EventMarker.fromEvent(event, store: store)
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
        print("Unwound to map")
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
    }
}

// Snarfed from https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
extension MapViewController: MKMapViewDelegate {

    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }

    // Gets called when I click a button
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isKind(of: EventMarkerDetail.self) {
            let marker = view as! EventMarkerDetail
            let eventModel = marker.eventModel
            
            let events: [Event] = store?.eventsForPerson(eventModel.personID) ?? []
            var coordinates = events.map({ CLLocation(latitude: $0.latitude, longitude: $0.longitude).coordinate })
            let line = MKGeodesicPolyline(coordinates: &coordinates, count: coordinates.count)
            lastLine = line
            mapView.addOverlay(line)
        }
    }

    // this gets called when I click *off* a button
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: EventMarkerDetail.self) {
            if let myLastLine = lastLine {
                mapView.removeOverlay(myLastLine)
                lastLine = nil
            }
        }
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EventMarker else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
             as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // if annotation.isKind(of: EventMarker.self) {
            view = EventMarkerDetail(annotation: annotation, reuseIdentifier: identifier, eventModel: store!.events[annotation.eventID]!)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let detailButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = detailButton
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! EventMarker
        self.performSegue(withIdentifier: "showPerson", sender: location)
    }
}
