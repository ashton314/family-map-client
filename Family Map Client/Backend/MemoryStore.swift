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
    private var _rawPeople: [String:Person]
    var people: [String:Person] { return _rawPeople }

    private var _rawEvents: [String:Event]
    var events: [String:Event] { return filterEvents(_rawEvents) }

    private var _rawEventsByPerson: [String:[Event]]
    var eventsByPerson: [String:[Event]] { return _rawEventsByPerson }
    private var _rawAuthToken: String
    var authToken: String { return _rawAuthToken }
    private var _rawRootPersonID: String
    var rootPersonID: String { return _rawRootPersonID }
    private var _rawHost: String
    var host: String { return _rawHost }
    private var _rawPort: String
    var port: String { return _rawPort }
    
    // Settings
    private var mapType: MKMapType = .standard
    func getMapType() -> MKMapType { return mapType }
    func setMapType(_ val: MKMapType) { mapType = val }

    private var lifeLineColor: UIColor = .blue
    func getLifeLineColor() -> UIColor { return lifeLineColor }
    func setLifeLineColor(_ val: UIColor) { lifeLineColor = val }

    private var familyLineColor: UIColor = .lightGray
    func getFamilyLineColor() -> UIColor { return familyLineColor }
    func setFamilyLineColor(_ val: UIColor) { familyLineColor = val }

    private var spouseLineColor: UIColor = .green
    func getSpouseLineColor() -> UIColor { return spouseLineColor }
    func setSpouseLineColor(_ val: UIColor) { spouseLineColor = val }

    private var showLifeLine: Bool = true
    func getShowLifeLine() -> Bool { return showLifeLine }
    func setShowLifeLine(_ val: Bool) { showLifeLine = val }

    private var showFamilyLine: Bool = true
    func getShowFamilyLine() -> Bool { return showFamilyLine }
    func setShowFamilyLine(_ val: Bool) { showFamilyLine = val }

    private var showSpouseLine: Bool = true
    func getShowSpouseLine() -> Bool { return showSpouseLine }
    func setShowSpouseLine(_ val: Bool) { showSpouseLine = val }


    // Filters
    private var showMaternal: Bool = true
    func getShowMaternal() -> Bool { return showMaternal }
    func setShowMaternal(_ val: Bool) { showMaternal = val }

    private var showPaternal: Bool = true
    func getShowPaternal() -> Bool { return showPaternal }
    func setShowPaternal(_ val: Bool) { showPaternal = val }

    private var showMale: Bool = true
    func getShowMale() -> Bool { return showMale }
    func setShowMale(_ val: Bool) { showMale = val }

    private var showFemale: Bool = true
    func getShowFemale() -> Bool { return showFemale }
    func setShowFemale(_ val: Bool) { showFemale = val }

    private var showEventTypes: [String:Bool] = [:]
    func getShowEventTypes(_ key: String) -> Bool { return showEventTypes[key] ?? false }
    func setShowEventTypes(_ key: String, _ val: Bool) { showEventTypes[key] = val }

    init(people: [String:Person], events:[String:Event], authToken: String, rootPerson: String, host: String, port: String) {
        self._rawPeople = people
        self._rawEvents = events
        self._rawAuthToken = authToken
        self._rawRootPersonID = rootPerson
        self._rawHost = host
        self._rawPort = port
        self._rawEventsByPerson = MemoryStore.transposeEventIndex(_rawEvents)
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
                self._rawPeople = Dictionary(uniqueKeysWithValues: people.map { ($0.personID, $0) })
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
                self._rawEventsByPerson = MemoryStore.transposeEventIndex(self._rawEvents)
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

    func nukeAuthToken() {
        _rawAuthToken = ""
    }

    func getFirstEvent(_ personID: String) -> Event? {
        let events = self.eventsForPerson(personID)
        return events.count > 0 ? events[0] : nil
    }
    func getParents(fromPerson personID: String) -> (String, String)? {
        if let me = self._rawPeople[personID] {
            return (me.father, me.mother) // since when did you become me motha?
        }
        else {
            return nil          // I'd stop y'er bawlin--- Hey! Who asked you?!
        }
    }

    func getChildren(personID: String) -> [Person] {
        var children: [Person] = []
        for (_, person) in _rawPeople {
            if person.father == personID || person.mother == personID {
                children.append(person)
            }
        }
        return children
    }

    func filterEvents(_ eventList: [String:Event]) -> [String:Event] {
        return eventList.filter(
          {_, event in
              if isMaternal(event) && !showMaternal { return false }
              if isPaternal(event) && !showPaternal { return false }
              if isMale(event) && !showMale { return false }
              if isFemale(event) && !showFemale { return false }
              return showEventTypes[event.eventType] ?? true
          })
    }

    func filterEvents(flatList eventList: [Event]) -> [Event] {
        return eventList.filter(
            {event in
                if isMaternal(event) && !showMaternal { return false }
                if isPaternal(event) && !showPaternal { return false }
                if isMale(event) && !showMale { return false }
                if isFemale(event) && !showFemale { return false }
                return showEventTypes[event.eventType] ?? true
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
        return _rawPeople[event.personID]!.gender == "m"
    }
    func isFemale(_ event: Event) -> Bool {
        return _rawPeople[event.personID]!.gender == "f"
    }

    // returns events where type is given in the array
    func getEventsWithTypes(_ types: [String]) -> [Event] {
        return self.events.map({ $1 }).filter({ types.contains($0.eventType) })
    }

    func eventsForPerson(_ personID: String) -> [Event] {
        return filterEvents(flatList: self.eventsByPerson[personID]?.sorted(by: { $0.year < $1.year }) ?? [])
    }

    // returns a unique set of Strings that cover the event.eventType field
    func eventTypes() -> [String] {
        var types = Set<String>()

        for (_, event) in self._rawEvents {
            types.insert(event.eventType)
        }

        return types.sorted()
    }

    // walks a person's lineage
    func walkTree(_ rootID: String) -> [Person] {
        if let rootPerson = self._rawPeople[rootID] {
            return [rootPerson] + walkTree(rootPerson.father) + walkTree(rootPerson.mother)
        }
        else {
            return []
        }
    }

    func filterBySide(rootID: String, side: TreeSide) -> [Person] {
        let rootPerson = self._rawPeople[rootID]
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
