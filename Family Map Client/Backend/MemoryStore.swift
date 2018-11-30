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
    var eventsByPerson: [String:[Event]]
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
        self.eventsByPerson = MemoryStore.transposeEventIndex(events)
    }

    func refreshPeople(callback: @escaping (Bool, Any) -> Void = {_,_ in } ) -> (Bool, String) {
        let sp = ServerProxy(host: self.host, port: self.port)
        let (ok, message) = sp.getPeople(authToken: self.authToken) { (ok, resp) in
            guard ok else {
                print("Not ok fetching people: \(resp)")
                callback(false, resp)
                return
            }
            if let people = resp as? [Person] {
                self.people = Dictionary(uniqueKeysWithValues: people.map { ($0.personID, $0) })
                print("ok fetching people")
                callback(ok, resp)
            }
            else {
                print("Could not parse response from server in updatePeople(): \(resp)")
            }
        }
        
        if !ok {
            print("Request to fetch people failed: \(message)")
            return (ok, message)
        }
        else {
            return (true, message)
        }
    }
    func refreshEvents(callback: @escaping (Bool, Any) -> Void = {_,_ in } ) -> (Bool, String) {
        let sp = ServerProxy(host: self.host, port: self.port)
        let (ok, message) = sp.getEvents(authToken: self.authToken) { (ok, resp) in
            guard ok else {
                print("Not ok fetching events: \(resp)")
                callback(false, resp)
                return
            }
            if let events = resp as? [Event] {
                self.events = Dictionary(uniqueKeysWithValues: events.map { ($0.eventID, $0) })
                print("got events")
                callback(ok, resp)
            }
            else {
                print("Could not parse response from server in updateEvents(): \(resp)")
            }
        }
        
        if !ok {
            print("Request to fetch events failed: \(message)")
            return (ok, message)
        }
        else {
            return (true, message)
        }
    }

    static func transposeEventIndex(_ events: [String:Event]) -> [String:[Event]] {
        var index: [String:[Event]] = [:]
        for (_, event) in events {
            if index[event.personID] == nil {
                index[event.personID] = []
            }
            index[event.personID]!.append(event)
        }
        return index
    }
}
