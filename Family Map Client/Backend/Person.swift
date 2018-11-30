//
//  Person.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class Person: Codable {

    let firstName: String
    let lastName: String

    let personID: String
    let descendant: String

    let mother: String
    let father: String
    let spouse: String

    let gender: String

    init(firstName: String, lastName: String, personID: String, descendant: String, mother: String, father: String, spouse: String, gender: String) {
        self.firstName  = firstName
        self.lastName   = lastName
        self.personID   = personID
        self.descendant = descendant
        self.mother     = mother
        self.father     = father
        self.spouse     = spouse
        self.gender     = gender
    }
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
