//
//  PersonViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    //------------------------------------------------
    //           NO LONGER IN USE
    //------------------------------------------------

    var store: MemoryStore?

    var currentPersonID: String?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var deathLabel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentPersonID = currentPersonID,
           let person = store!.people[currentPersonID] {
            print("Setting name label: \(person.firstName) \(person.lastName)")
            nameLabel.text = "\(person.firstName) \(person.lastName)"
            genderLabel.text = person.gender == "m" ? "Male" : "Female"
        }
    }

    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination.isKind(of: PersonDetailController.self) {
//            if let dest = segue.destination as? PersonDetailController {
//                dest.currentPersonID
//            }
//        }
//    }

}
