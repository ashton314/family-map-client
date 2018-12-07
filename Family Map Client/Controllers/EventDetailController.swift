//
//  EventDetailController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-06.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class EventDetailController: UIViewController {


    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!

    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let event = event {
            eventType.text = event.eventType
            eventLocation.text = "\(event.city), \(event.country)"
            eventDate.text = event.year
        }
    }
}
