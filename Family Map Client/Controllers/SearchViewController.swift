//
//  SearchViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-12.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    var store: MemoryStore?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1                // FIXME
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let store = store else { fatalError("no store supplied") }

        if indexPath.section == 0 { // people
            let all_people = store.people.values.sorted(by: { $0.personID < $1.personID })
            let cell = tableView.dequeueReusableCell(withIdentifier: "familyMemberCell", for: indexPath) as! FamilyMemberCell

            cell.updateFrom(person: all_people[indexPath.row], relation: "") // TODO: maybe compute relationship to root person for fun? Naw... this thing's due tomorrow.
            return cell         // It's been an interesting night, believe me
        }
        else if indexPath.section == 1 { // events
            let all_events = store.events.values.sorted(by: { $0.eventID < $1.eventID })
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventViewCell

            cell.update(with: all_events[indexPath.row])

            return cell
        }
        else {
            fatalError("somehow got outside of section boundaries")
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIView else { return }

        if segue.destination.isKind(of: PersonDetailController.self) {
            let dest = segue.destination as! PersonDetailController
            let person: Person

            if sender.isKind(of: FamilyMemberCell.self) {
                let sender = sender as! FamilyMemberCell
                person = sender.basePerson!
            }
            else {
                let sender = sender as! EventViewCell // meant to be fatal---the app should explode at this point if this fails
                person = store!.people[sender.myEvent!.personID]!
            }

            dest.store = store
            dest.title = "\(person.fullName())"
            dest.currentPersonID = person.personID
        }
    }
}
