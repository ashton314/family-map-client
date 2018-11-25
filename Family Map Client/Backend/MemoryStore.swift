//
//  MemoryStore.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class MemoryStore {
    let people: [String:Person]
    let events: [String:Event]
    let authToken: String
    let rootPersonID: String

    init(people: [String:Person], events:[String:Event], authToken: String, rootPerson: String) {
        self.people = people
        self.events = events
        self.authToken = authToken
        self.rootPersonID = rootPerson
    }
}
