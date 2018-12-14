//
//  FilterTests.swift
//  Family Map ClientTests
//
//  Created by Ashton Wiersdorf on 2018-12-12.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import XCTest
@testable import Family_Map_Client

class FilterTests: XCTestCase {

    var store = MemoryStore(people: ["me": Person(firstName: "Foo", lastName: "Bar", personID: "foo", descendant: "me", mother: "foo_mom", father: "foo_dad", spouse: "", gender: "m"),
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

    override func setUp() {
    }
    override func tearDown() {
    }

    func testIdenificationMethods() {
        let dad_event = store.events["event_5"]!
        let mom_event = store.events["event_4"]!

        XCTAssert(store.isPaternal(dad_event))
        XCTAssert(!store.isMaternal(dad_event))
        XCTAssert(store.isMale(dad_event))
        XCTAssert(!store.isFemale(dad_event))

        XCTAssert(!store.isPaternal(mom_event))
        XCTAssert(store.isMaternal(mom_event))
        XCTAssert(!store.isMale(mom_event))
        XCTAssert(store.isFemale(mom_event))
    }

    func testEventFiltering() {
        store.setShowMaternal(false)
        XCTAssertNil(store.events["event_4"])
        XCTAssertNotNil(store.events["event_5"])
        store.setShowMaternal(true)
        XCTAssertNotNil(store.events["event_4"])
        XCTAssertNotNil(store.events["event_5"])

        store.setShowMale(false)
        XCTAssertNotNil(store.events["event_4"])
        XCTAssertNil(store.events["event_5"])
        store.setShowFemale(false)
        XCTAssertNil(store.events["event_4"])
        XCTAssertNil(store.events["event_5"])
        store.setShowMale(true)
        XCTAssertNil(store.events["event_4"])
        XCTAssertNotNil(store.events["event_5"])
        store.setShowFemale(true)
        XCTAssertNotNil(store.events["event_4"])
        XCTAssertNotNil(store.events["event_5"])

    }
}
