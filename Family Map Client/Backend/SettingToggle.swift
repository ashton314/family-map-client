//
//  SettingToggle.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-04.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class SettingToggle {
    let title: String
    var state: Bool
    
    init(title: String, state: Bool) {
        self.title = title
        self.state = state
    }
}
