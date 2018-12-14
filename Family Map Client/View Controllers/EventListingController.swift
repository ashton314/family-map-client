//
//  EventListingController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-05.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class EventListingController: UITableViewController {

    var events: [Event]?
    var store: MemoryStore?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0,
           let events = events {
            return events.count
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventViewCell

        guard let events = events else { return cell }

        let sorted_events = events.sorted(by: { $0.year < $1.year })
        let event = sorted_events[indexPath.row]

        cell.update(with: event)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: EventDetailController.self) {
            if let dest = segue.destination as? EventDetailController,
                let source = sender as? EventViewCell {
                dest.event = source.myEvent
            }
        }
    }

}
