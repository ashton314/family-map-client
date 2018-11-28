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

    @IBOutlet weak var mainMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Family Map"
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

    func updateMap() {
        print("Updating map points...")
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: PersonViewController.self) {
            if let dest = segue.destination as? PersonViewController {
                dest.store = store
            }
        }
    }

}
