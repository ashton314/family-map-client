//
//  FilterViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-12.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    var store: MemoryStore?
    var eventTypes: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let store = store else { return }
        eventTypes = store.eventTypes()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let eventTypes = eventTypes else { return 0 }
        return section == 0 ? 4 : eventTypes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterViewCell

        guard let store = store,
              let eventTypes = eventTypes else { return cell }

        var title: String = ""
        var getter: () -> Bool = { false }  // noop
        var setter: (Bool) -> () = { _ in } // noop

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                (getter, setter) = ({ store.showMaternal }, { store.showMaternal = $0 })
                title = "Show Maternal Side"
            case 1:
                (getter, setter) = ({ store.showPaternal }, { store.showPaternal = $0 })
                title = "Show Paternal Side"
            case 2:
                (getter, setter) = ({ store.showFemale }, { store.showFemale = $0 })
                title = "Show Female"
            case 3:
                (getter, setter) = ({ store.showMale }, { store.showMale = $0 })
                title = "Show Male"
            default:
                break
            }
        case 1:
            let type = eventTypes[indexPath.row]
            (getter, setter) = ({ store.showEventTypes[type] ?? false }, { store.showEventTypes[type] = $0 })
            title = type
        default:
            break
        }

        cell.update(title: title, withSetter: setter, withGetter: getter)

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["General Filters", "Event Filters"]
        return titles[section]
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
