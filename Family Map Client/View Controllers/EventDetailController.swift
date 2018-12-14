//
//  EventDetailController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-06.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit
import MapKit

class EventDetailController: UIViewController {

    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    
    var event: Event?
    var store: MemoryStore?
    
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
