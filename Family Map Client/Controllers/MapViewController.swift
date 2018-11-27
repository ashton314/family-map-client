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
        print("MapViewController coming into focus...")
        if let store = store {
            print("store already initilized")
            // OK, we can do stuff with store now
            let sp = ServerProxy(host: store.host, port: store.port)
            print("Host: \(store.host), port: \(store.port)")
            print("Auth token: \(store.authToken), root person: \(store.rootPersonID)")
            let (ok, message) = sp.getPerson(authToken: store.authToken, personID: store.rootPersonID) {
                (ok, resp) in
                if let rootPerson = resp as? Person {
                    self.doAlert("Root Person", message: "\(rootPerson.firstName) \(rootPerson.lastName)")
                }
            }
            if !ok {
                print("Problem: \(message)")
                return
            }
            
            let (ok2, message2) = sp.getPeople(authToken: store.authToken) {
                (ok, resp) in
                if let people = resp as? [Person] {
                    store.people = Dictionary(uniqueKeysWithValues: people.map { ($0.personID, $0) })
                } else {
                    print("Response that failed to become an array of people: \(resp)")
                    self.doAlert("Error", message: "Couldn't parse server response!")
                }
            }
            if !ok2 {
                print("Problem: \(message2)")
                return
            }

        }
        else {
            print("Augh! WE don't have a data store")
            self.performSegue(withIdentifier: "doAuth", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        print("MapViewController: here I am!")
    }

    func doAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMap(unwindSeuge: UIStoryboardSegue) {
        print("Done got unwound to map!")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: PersonViewController.self) {
            if let dest = segue.destination as? PersonViewController {
                dest.store = store
            }
        }
    }

}
