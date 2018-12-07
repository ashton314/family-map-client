//
//  EventViewCell.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-05.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var myEvent: Event?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with event: Event) {
        titleLabel.text = "\(event.eventType) (\(event.year))"
        subtitleLabel.text = "\(event.city), \(event.country)"
        myEvent = event
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
