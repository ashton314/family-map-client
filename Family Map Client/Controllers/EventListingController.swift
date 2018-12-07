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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

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

        print("in updater")

        guard let events = events else { print("awe snap... no events"); return cell }
        let event = events[indexPath.row]

        print("we got an event"); print(event)
        cell.update(with: event)

        return cell
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
