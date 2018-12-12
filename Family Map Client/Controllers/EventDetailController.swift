//
//  EventDetailController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-06.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit
import MapKit

class EventDetailController: UIViewController {


    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    
    var event: Event?
    var store: MemoryStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let event = event {
            eventType.text = event.eventType
            eventLocation.text = "\(event.city), \(event.country)"
            eventDate.text = event.year
            updateEvents()
        }
    }
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        eventMap.setRegion(coordinateRegion, animated: true)
    }
    func updateEvents() {
        guard let store = store,
              let event = event else {return}
        let initialLocation = CLLocation(latitude: event.latitude, longitude: event.longitude)
        centerMapOnLocation(location: initialLocation)
        
        let marker = EventMarker.fromEvent(event, store: store)
        eventMap.addAnnotation(marker)
    }
}

extension EventDetailController: MKMapViewDelegate {
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let store = store else { return MKOverlayRenderer() }
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        
        switch polyline.title {
        case "lifeLine": renderer.strokeColor = store.lifeLineColor
        case "spouseLine": renderer.strokeColor = store.spouseLineColor
        case "familyLine":
            renderer.strokeColor = store.familyLineColor
            let power = Int(polyline.subtitle ?? "0") ?? 0
            let denominator = Double(power == 0 ? 1 : 2 << power)
            renderer.lineWidth = CGFloat(3.0 * (1.0 / denominator))
        default: renderer.strokeColor = UIColor.blue
        }
        
        return renderer
    }
    
    // Gets called when I click a button
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if view.isKind(of: EventMarkerDetail.self) {
//            let marker = view as! EventMarkerDetail
//            let eventModel = marker.eventModel
//
//            let personID = eventModel.personID
//            drawLifeLines(for: personID, mapView: mapView)
//            drawFamilyLines(for: personID, mapView: mapView, generation: 0)
//            drawSpouseLines(for: personID, mapView: mapView)
//        }
//    }
    
    // this gets called when I click *off* a button
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        if view.isKind(of: EventMarkerDetail.self) {
//            for line in lastLines {
//                mapView.removeOverlay(line)
//            }
//            lastLines = []
//        }
//    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EventMarker else { return nil }
        let identifier = "marker-\(annotation.eventID)"
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
