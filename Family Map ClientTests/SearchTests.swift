//
//  SearchTests.swift
//  Family Map ClientTests
//
//  Created by Ashton Wiersdorf on 2018-12-13.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import XCTest
@testable import Family_Map_Client

class SearchTests: XCTestCase {

    var store: MemoryStore?

    override func setUp() {
        store = MemoryStore(people: ["me": Person(firstName: "Foo", lastName: "Bar", personID: "foo", descendant: "me", mother: "foo_mom", father: "foo_dad", spouse: "", gender: "m"),
                                     "foo_mom": Person(firstName: "Foo_mom", lastName: "Bar", personID: "foo_mom", descendant: "me", mother: "foo_mom_mom",
                                                       father: "foo_mom_dad", spouse: "foo_dad", gender: "f"),
                                     "foo_dad": Person(firstName: "Foo_dad", lastName: "Bar", personID: "foo_dad", descendant: "me", mother: "foo_dad_mom",
                                                       father: "foo_dad_dad", spouse: "foo_mom", gender: "m"),
                                     "foo_mom_mom": Person(firstName: "foo_mom_mom", lastName: "Bar", personID: "foo_mom_mom", descendant: "me", mother: "foo_mom_mom_mom",
                                                           father: "foo_mom_mom_dad", spouse: "foo_mom_dad", gender: "f"),
                                     "foo_mom_dad": Person(firstName: "foo_mom_dad", lastName: "Bar", personID: "foo_mom_dad", descendant: "me", mother: "foo_mom_dad_mom",
                                                           father: "foo_mom_dad_dad", spouse: "foo_mom_mom", gender: "m"),
                                     "foo_dad_mom": Person(firstName: "foo_dad_mom", lastName: "Bar", personID: "foo_dad_mom", descendant: "me", mother: "foo_dad_mom_mom",
                                                           father: "foo_dad_mom_dad", spouse: "foo_dad_dad", gender: "f"),
                                     "foo_dad_dad": Person(firstName: "foo_dad_dad", lastName: "Bar", personID: "foo_dad_dad", descendant: "me", mother: "foo_dad_dad_mom",
                                                           father: "foo_dad_dad_dad", spouse: "foo_dad_mom", gender: "m")],
                            events: ["event_1": Event(id: "event_1", event_type: "birth", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1974",
                                                      person_id: "me", owner_id: "me"),
                                     "event_2": Event(id: "event_2", event_type: "death", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1994",
                                                      person_id: "me", owner_id: "me"),
                                     "event_3": Event(id: "event_3", event_type: "birth", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1974",
                                                      person_id: "foo_mom", owner_id: "me"),
                                     "event_4": Event(id: "event_4", event_type: "death", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1995",
                                                      person_id: "foo_mom", owner_id: "me"),
                                     "event_5": Event(id: "event_5", event_type: "birth", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1974",
                                                      person_id: "foo_dad", owner_id: "me"),
                                     "event_6": Event(id: "event_6", event_type: "anathema", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1994",
                                                      person_id: "foo_dad", owner_id: "me"),
                                     "event_7": Event(id: "event_7", event_type: "death", latitude: 42.1, longitude: 42.1, country: "Wakanda", city: "Capitol", year: "1995",
                                                      person_id: "foo_dad", owner_id: "me"),
                                     ],
                            authToken: "authytoken", rootPerson: "me", host: "127.0.0.1", port: "8080")
    }

    // These methods search finding everyone, then one, three, and finally zero people
    func testSearchNothing() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "")
        XCTAssertEqual(svc.filtered_people.count, 7)
        XCTAssertEqual(svc.filtered_events.count, 7)
    }
    func testSearchToOnePerson() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "foo_mom_mom")
        XCTAssertEqual(svc.filtered_people.count, 1)
        XCTAssertEqual(svc.filtered_events.count, 0)
        XCTAssertEqual(svc.filtered_people.values.sorted(by: { $0.personID < $1.personID })[0], store?.people["foo_mom_mom"])
    }
    func testSearchToThreePeople() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "foo_mom")
        XCTAssertEqual(svc.filtered_people.count, 3)
        XCTAssertEqual(svc.filtered_events.count, 0)
        XCTAssertEqual(svc.filtered_people.values.sorted(by: { $0.personID < $1.personID }),
                       ["foo_mom", "foo_mom_dad", "foo_mom_mom"].map({ (key: String) -> Person in (store?.people[key])! } ))
    }
    func testSearchToNobody() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "trogdor")
        XCTAssertEqual(svc.filtered_people.count, 0)
        XCTAssertEqual(svc.filtered_events.count, 0)
    }


    // these methods test finding one, three, and zero events
    func testSearchToOneEvent() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "anathema")
        XCTAssertEqual(svc.filtered_people.count, 0)
        XCTAssertEqual(svc.filtered_events.count, 1)
        XCTAssertEqual(svc.filtered_events.values.sorted(by: { $0.eventID < $1.eventID })[0], store?.events["event_6"])
    }
    func testSearchToThreeEvents() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "birth")
        XCTAssertEqual(svc.filtered_people.count, 0)
        XCTAssertEqual(svc.filtered_events.count, 3)
        XCTAssertEqual(svc.filtered_events.values.sorted(by: { $0.eventID < $1.eventID }),
                       ["event_1", "event_3", "event_5"].map({ (key: String) -> Event in (store?.events[key])! } ))
    }
    func testSearchToNoEvents() {
        let svc = SearchViewController()
        svc.store = store
        svc.setSearchText(text: "burninate")
        XCTAssertEqual(svc.filtered_people.count, 0)
        XCTAssertEqual(svc.filtered_events.count, 0)
    }
}
