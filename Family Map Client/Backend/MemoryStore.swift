//
//  MemoryStore.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation
import MapKit

enum TreeSide {
    case paternal, maternal
}

class MemoryStore {
    var people: [String:Person]
    private var _rawEvents: [String:Event]

    var events: [String:Event] { return filterEvents(_rawEvents) }
    var eventsByPerson: [String:[Event]]
    var authToken: String
    var rootPersonID: String
    var host: String
    var port: String
    
    // Settings
    var mapType: MKMapType = .standard
    var lifeLineColor: UIColor = .blue
    var familyLineColor: UIColor = .lightGray
    var spouseLineColor: UIColor = .green
    var showLifeLine = true
    var showFamilyLine = true
    var showSpouseLine = true

    // Filters
    var showMaternal = true
    var showPaternal = true
    var showMale = true
    var showFemale = true
    var showEventTypes: [String:Bool] = [:]

    init(people: [String:Person], events:[String:Event], authToken: String, rootPerson: String, host: String, port: String) {
        self.people = people
        self._rawEvents = events
        self.authToken = authToken
        self.rootPersonID = rootPerson
        self.host = host
        self.port = port
        self.eventsByPerson = MemoryStore.transposeEventIndex(_rawEvents)
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
                self._rawEvents = Dictionary(uniqueKeysWithValues: events.map { ($0.eventID, $0) })
                self.eventsByPerson = MemoryStore.transposeEventIndex(self._rawEvents)
                print("got events")

                self.showEventTypes = Dictionary(uniqueKeysWithValues: self.eventTypes().map({ ($0, true) }))

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

    func getFirstEvent(_ personID: String) -> Event? {
        let events = self.eventsForPerson(personID)
        return events.count > 0 ? events[0] : nil
    }
    func getParents(fromPerson personID: String) -> (String, String)? {
        if let me = self.people[personID] {
            return (me.father, me.mother) // since when did you become me motha?
        }
        else {
            return nil          // I'd stop y'er bawlin--- Hey! Who asked you?!
        }
    }

    func getChildren(personID: String) -> [Person] {
        var children: [Person] = []
        for (_, person) in people {
            if person.father == personID || person.mother == personID {
                children.append(person)
            }
        }
        return children
    }

    func filterEvents(_ eventList: [String:Event]) -> [String:Event] {
        return eventList.filter(
          {key, event in
              if isMaternal(event) && !showMaternal { return false }
              if isPaternal(event) && !showPaternal { return false }
              if isMale(event) && !showMale { return false }
              if isFemale(event) && !showFemale { return false }
              return true
          })
    }

    func isMaternal(_ event: Event) -> Bool {
        let moms_family = filterBySide(rootID: rootPersonID, side: .maternal)
        return moms_family.contains(where: { $0.personID == event.personID })
    }
    func isPaternal(_ event: Event) -> Bool {
        let dads_family = filterBySide(rootID: rootPersonID, side: .paternal)
        return dads_family.contains(where: { $0.personID == event.personID })
    }
    func isMale(_ event: Event) -> Bool {
        return people[event.personID]!.gender == "m"
    }
    func isFemale(_ event: Event) -> Bool {
        return people[event.personID]!.gender == "f"
    }

    // returns events where type is given in the array
    func getEventsWithTypes(_ types: [String]) -> [Event] {
        return self.events.map({ $1 }).filter({ types.contains($0.eventType) })
    }

    func eventsForPerson(_ personID: String) -> [Event] {
        return self.eventsByPerson[personID]?.sorted(by: { $0.year < $1.year }) ?? []
    }

    // returns a unique set of Strings that cover the event.eventType field
    func eventTypes() -> [String] {
        var types = Set<String>()

        for (_, event) in self.events {
            types.insert(event.eventType)
        }

        return types.sorted()
    }

    // walks a person's lineage
    func walkTree(_ rootID: String) -> [Person] {
        if let rootPerson = self.people[rootID] {
            return [rootPerson] + walkTree(rootPerson.father) + walkTree(rootPerson.mother)
        }
        else {
            return []
        }
    }

    func filterBySide(rootID: String, side: TreeSide) -> [Person] {
        let rootPerson = self.people[rootID]
        let firstParent = side == .paternal ? rootPerson?.father : rootPerson?.mother
        return walkTree(firstParent!)
    }

    // Takes a map event_id -> Event and returns a map person_id -> [Event], so events
    // can be retrieved by person_id
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
