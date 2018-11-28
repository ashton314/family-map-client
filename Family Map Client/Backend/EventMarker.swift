//
//  EventMarker.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-27.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation
import MapKit

class EventMarker: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }

    static func fromEvent(_ event: Event) -> EventMarker {
        return EventMarker(title: event.eventType, locationName: "\(event.city), \(event.country)", discipline: event.eventType,
                           coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
    }
}
