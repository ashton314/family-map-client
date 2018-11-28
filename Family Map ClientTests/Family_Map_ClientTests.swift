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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testRefreshPeople() {
        let store = MemoryStore(people: [:], events: [:], authToken: "ff8c7f26-abcc-4061-9f22-50da93178e1d",
                                rootPerson: "1086", host: "127.0.0.1", port: "8080")
        XCTAssert(store.people.count == 0, "we have no people in our store")
        let (refresh_ok, refresh_message) = store.refreshPeople() {
            (fetch_ok, fetch_message) in
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

//        for _ in 1...5 {
//            print("checking for events...")
//            if store.events.count == 0 {
//                print("nope")
//            }
//            else {
//                print("yup!")
//                break
//            }
//            print("sleeping for 1 second...")
//            sleep(1)
//        }
//        print("giving up")

        XCTAssertTrue(refresh_ok, "problem refreshing events: \(refresh_message)")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
