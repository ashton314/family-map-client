//
//  FamilyViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-11.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class FamilyViewController: UITableViewController {

    var store: MemoryStore?
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let person = person else { return }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let person = person,
              let store  = store else { return 0 }

        switch section {
        case 0: return (person.father != "" ? 1 : 0) + (person.mother != "" ? 1 : 0)
        case 1: return (person.spouse != "" ? 1 : 0)
        case 2: return store.getChildren(personID: person.personID).count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["Parents", "Spouse", "Children"]
        return titles[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "familyMemberCell", for: indexPath) as! FamilyMemberCell
        guard let store = store,
              let person = person else { return cell }

        switch indexPath.section {
        case 0:
            if let parent = store.people[indexPath.row == 0 ? person.father : person.mother] {
                cell.updateFrom(person: parent, relation: indexPath.row == 0 ? "Father" : "Mother")
            }
        case 1:
            if let spouse = store.people[person.spouse] {
                cell.updateFrom(person: spouse, relation: "Spouse")
            }
        case 2:
            cell.updateFrom(person: store.getChildren(personID: person.personID)[indexPath.row], relation: "Child")
        default:
            break
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: PersonDetailController.self) {
            if let sender = sender as? FamilyMemberCell,
                let basePerson = sender.basePerson {

                let dest = segue.destination as! PersonDetailController
                dest.title = basePerson.fullName()
                dest.store = store
                dest.currentPersonID = basePerson.personID
            }
        }
    }

}
