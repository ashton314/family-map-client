//
//  EventDetails.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-06.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class EventDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func update(with str: String) {
        titleLabel.text = "FIXME"
        subtitleLabel.text = str
    }
}

class EventDetails: UITableView {

    static let staticDetails = ["Title", "Location", "Time"]

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventDetailCell", for: indexPath) as! EventDetailCell
        
        cell.update(with: EventDetails.staticDetails[indexPath.row])
        return cell
    }

}
