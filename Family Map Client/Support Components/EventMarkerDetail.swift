//
//  EventMarkerDetail.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-08.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit
import MapKit

class EventMarkerDetail: MKMarkerAnnotationView {
    var eventModel: Event

    init(annotation: MKAnnotation, reuseIdentifier: String, eventModel: Event) {
        self.eventModel = eventModel
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
