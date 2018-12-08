//
//  PersonModelTest.swift
//  Family Map ClientTests
//
//  Created by Ashton Wiersdorf on 2018-12-07.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import XCTest
@testable import Family_Map_Client

class PersonModelTest: XCTestCase {

    var store = MemoryStore(people: ["me": Person(firstName: "Foo", lastName: "Bar", personID: "foo", descendant: "me", mother: "foo_mom", father: "foo_dad", spouse: "", gender: "m"),
                                     "foo_mom": Person(firstName: "Foo_mom", lastName: "Bar", personID: "foo_mom", descendant: "me", mother: "foo_mom_mom", father: "foo_mom_dad", spouse: "foo_dad", gender: "f"),
                                     "foo_dad": Person(firstName: "Foo_dad", lastName: "Bar", personID: "foo_dad", descendant: "me", mother: "foo_dad_mom", father: "foo_dad_dad", spouse: "foo_mom", gender: "m"),
                                     "foo_mom_mom": Person(firstName: "foo_mom_mom", lastName: "Bar", personID: "foo_mom_mom", descendant: "me", mother: "foo_mom_mom_mom", father: "foo_mom_mom_dad", spouse: "foo_mom_dad", gender: "f"),
                                     "foo_mom_dad": Person(firstName: "foo_mom_dad", lastName: "Bar", personID: "foo_mom_dad", descendant: "me", mother: "foo_mom_dad_mom", father: "foo_mom_dad_dad", spouse: "foo_mom_mom", gender: "m"),
                                     "foo_dad_mom": Person(firstName: "foo_dad_mom", lastName: "Bar", personID: "foo_dad_mom", descendant: "me", mother: "foo_dad_mom_mom", father: "foo_dad_mom_dad", spouse: "foo_dad_dad", gender: "f"),
                                     "foo_dad_dad": Person(firstName: "foo_dad_dad", lastName: "Bar", personID: "foo_dad_dad", descendant: "me", mother: "foo_dad_dad_mom", father: "foo_dad_dad_dad", spouse: "foo_dad_mom", gender: "m")],
                            events: [:], authToken: "authytoken", rootPerson: "me", host: "127.0.0.1", port: "8080")

    override func setUp() {

    }

    override func tearDown() {
    }

    func testTreeSides() {
        print(store.filterBySide(rootID: "me", side: .maternal))
        XCTAssertEqual(store.filterBySide(rootID: "me", side: .maternal), ["foo_mom","foo_mom_dad","foo_mom_mom"].map({ (i: String) -> Person in
            return store.people[i]!
        }))
//        XCTAssert(store.filterBySide(rootID: "me", side: .maternal) == ["foo_mom","foo_mom_mom","foo_mom_dad"].map({ (i: String) -> Person in
//            return store.people[i]!
//        }), "sides equal")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
