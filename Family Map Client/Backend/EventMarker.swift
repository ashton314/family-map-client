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

    let store: MemoryStore

    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let personID: String
    let eventID: String
    
    init(locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, personID: String, eventID: String, store: MemoryStore) {
//        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.personID = personID
        self.eventID = eventID
        self.store = store
        
        super.init()
    }
    
    var title: String? {
        if let person = store.people[personID] {
            return "\(person.fullName()): \(discipline)"
        }
        else {
            return discipline
        }
    }

    var subtitle: String? {
        return locationName
    }

    var markerTintColor: UIColor {
        let eventTypes = store.eventTypes()
        let colors: [UIColor] = [.blue, .green, .red, .purple, .lightGray, .orange, .brown, .cyan, .gray, .magenta, .darkGray, .white, .yellow, .black];
        let idx: Int = eventTypes.firstIndex(of: self.discipline) ?? 0
        print("idx: \(idx)")
        return colors[idx % colors.count]
    }

    static func fromEvent(_ event: Event, store: MemoryStore) -> EventMarker {
        return EventMarker(locationName: "\(event.city), \(event.country)", discipline: event.eventType,
                           coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude),
                           personID: event.personID, eventID: event.eventID, store: store)
    }
}
