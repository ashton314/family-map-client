//
//  Person.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class Person: Codable, Equatable, CustomStringConvertible {

    let firstName: String
    let lastName: String

    let personID: String
    let descendant: String

    let mother: String
    let father: String
    let spouse: String

    let gender: String

    var description: String {
        return "Person(firstName: \(firstName), lastName: \(lastName), personID: \(personID), descendant: \(descendant), mother: \(mother), father: \(father), spouse: \(spouse), gender: \(gender))"
    }

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

    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.personID == rhs.personID;
    }
}
