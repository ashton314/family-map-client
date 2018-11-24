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
    func doLogin(username: String, password: String, callback: @escaping (Bool, String) -> Void) -> (Bool, String) {
        if let url = URL(string: "http://\(host):\(port)/user/login") {
            print("URL: \(url)")
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let stringified = String(data: data, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        callback(true, stringified)
                    }
//                    callback(true, stringified)
                }
                else {
                    print("Response: \(response.debugDescription)")
                    let errorMessage = error?.localizedDescription ?? "Unknown error"
                    print("Pretty error: \(errorMessage)")
                    print(error.debugDescription)
                    DispatchQueue.main.async {
                        callback(false, errorMessage)
                    }
//                    callback(false, errorMessage)
                }
            }
            task.resume()
            return (true, "Good URL")
        }
        else {
            return (false, "Bad URL")
        }
    }
}
