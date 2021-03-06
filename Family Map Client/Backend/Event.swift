//
//  Event.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class Event: Codable, Equatable, CustomStringConvertible, Hashable {

    // All these are constants
    let eventID: String
    let eventType: String

    let latitude: Double
    let longitude: Double

    let country: String
    let city: String
    let year: String

    let personID: String
    let descendant: String

    var description: String {
        return "Event(id: \(eventID), event_type: \(eventType), latitude: \(latitude), country: \(country), city: \(city), year: \(year), personID: \(personID), descendant: \(descendant))"
    }

    init(id: String, event_type: String, latitude: Double, longitude: Double, country: String, city: String, year: String, person_id: String, owner_id: String) {
        self.eventID = id
        self.eventType = event_type
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.city = city
        self.year = year
        self.personID = person_id
        self.descendant = owner_id
    }

    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.eventID == rhs.eventID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(eventID)
    }
}
