//
//  PersonDetailController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-05.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class PersonDetailController: UITableViewController {

    var store: MemoryStore?
    var currentPersonID: String?

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personGender: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let currentPersonID = currentPersonID,
           let person = store!.people[currentPersonID] {
            print("Setting name label: \(person.firstName) \(person.lastName)")
            personName.text   = "\(person.lastName), \(person.firstName)"
            personGender.text = person.gender == "m" ? "Male" : "Female"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: EventListingController.self) {
            if let dest = segue.destination as? EventListingController {
                print("setting events in target with id \(currentPersonID)")
                dest.events = store?.eventsByPerson[currentPersonID!]
                print(dest.events)
            }
        }
    }
}
