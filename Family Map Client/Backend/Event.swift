//
//  Event.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class Event: Codable {
    let id: String
    let event_type: String

    let latitude: Double
    let longitude: Double

    let country: String
    let city: String

    let timestamp: String

    let person_id: String
    let owner_id: String

    init(id: String, event_type: String, latitude: Double, longitude: Double, country: String, city: String, timestamp: String, person_id: String, owner_id: String) {
        self.id = id
        self.event_type = event_type
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.city = city
        self.timestamp = timestamp
        self.person_id = person_id
        self.owner_id = owner_id
    }
}
