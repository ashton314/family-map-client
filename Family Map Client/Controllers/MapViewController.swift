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
        if let store = store {
            let (ok, message) = store.refreshPeople()
            if !ok {
                print("Problem updating list of people: \(message)")
                doAlert("Error", message: "Problem fetching people: \(message)")
            }
        }
        else {
            self.performSegue(withIdentifier: "doAuth", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //
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
