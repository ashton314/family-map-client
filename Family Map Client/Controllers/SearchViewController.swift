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
    
    let searchController = UISearchController(searchResultsController: nil)
    var search_text: String = ""

    var filtered_people: [String:Person] {
        return store?.people.filter({_, person in search_text == "" || person.fullName().lowercased().contains(search_text.lowercased()) }) ?? [:]
    }
    var filtered_events: [String:Event] {
        return store?.events.filter({_, event in search_text == "" || "\(event.city) \(event.country) \(event.eventType) \(event.year)".lowercased().contains(search_text.lowercased()) }) ?? [:]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? filtered_people.count : filtered_events.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["People", "Events"]
        return titles[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // people
            let person = filtered_people.values.sorted(by: { $0.personID < $1.personID })[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "familyMemberCell", for: indexPath) as! FamilyMemberCell

            cell.updateFrom(person: person, relation: person.gender == "m" ? "male" : "female")
            return cell         // It's been an interesting night, believe me
        }
        else if indexPath.section == 1 { // events
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventViewCell
            let event = filtered_events.values.sorted(by: { $0.eventID < $1.eventID })[indexPath.row]
            let person = store!.people[event.personID]!

            cell.update(with: event)
            cell.titleLabel.text = "\(event.eventType): \(person.fullName()) (\(event.year))"

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

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        search_text = searchController.searchBar.text!
        tableView.reloadData()
    }
}
