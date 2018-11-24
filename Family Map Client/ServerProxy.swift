//
//  ServerProxy.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-23.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import Foundation

class ServerProxy {
    var host: String
    var port: String

    init(host: String, port: String) {
        self.host = host
        self.port = port
    }
    func doLogin(host: String, port: String, username: String, password: String) -> (Bool, String) {
        if let url = URL(string: "http://\(host):\(port)") {
            print(url)
            return (true, "Got a good URL")
        }
        else {
            return (false, "Bad URL")
        }
    }
}
