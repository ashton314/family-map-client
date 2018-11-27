//
//  MemoryStore.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class MemoryStore {
    var people: [String:Person]
    var events: [String:Event]
    var authToken: String
    var rootPersonID: String
    var host: String
    var port: String

    init(people: [String:Person], events:[String:Event], authToken: String, rootPerson: String, host: String, port: String) {
        self.people = people
        self.events = events
        self.authToken = authToken
        self.rootPersonID = rootPerson
        self.host = host
        self.port = port
    }
}
