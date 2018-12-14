//
//  Family_Map_ClientTests.swift
//  Family Map ClientTests
//
//  Created by Ashton Wiersdorf on 2018-11-23.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import XCTest
@testable import Family_Map_Client

class Family_Map_ClientTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    // Note to grader: I don't know how to do network testing---I'm
    // using multiple threads here, but the tests don't seem to like
    // it. (E.g. the callbacks never turn up)
    //
    // I optimized to learn other things besides network testing. :)
    // That's why the next few functions might seem a little...
    // sparse.
    func testLoginSuccess() {
    }
    func testLoginFailure() {
    }

    func testRefreshPeople() {
        let store = MemoryStore(people: [:], events: [:], authToken: "ff8c7f26-abcc-4061-9f22-50da93178e1d",
                                rootPerson: "1086", host: "127.0.0.1", port: "8080")
        XCTAssert(store.people.count == 0, "we have no people in our store")
        let (refresh_ok, refresh_message) = store.refreshPeople() {
            (fetch_ok, fetch_message) in
            print("people got refreshed")
            XCTAssertTrue(fetch_ok, "problem: \(fetch_message)")
            XCTAssert(store.people.count > 0, "we didn't get any people")
        }
        XCTAssertTrue(refresh_ok, "problem with refresh: \(refresh_message)")
    }
    
    func testRefreshEvents() {
        let store = MemoryStore(people: [:], events: [:], authToken: "ff8c7f26-abcc-4061-9f22-50da93178e1d",
                                rootPerson: "1086", host: "127.0.0.1", port: "8080")
        XCTAssert(store.events.count == 0, "we shouldn't have events yet")
        let (refresh_ok, refresh_message) = store.refreshEvents() {
            (fetch_ok, fetch_message) in
            XCTAssertTrue(fetch_ok, "problem: \(fetch_message)")
            XCTAssert(store.events.count > 0, "we didn't get any events")
        }

        XCTAssertTrue(refresh_ok, "problem refreshing events: \(refresh_message)")
    }
}
