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

        struct LoginRequest: Codable {
            let userName: String
            let password: String
        }

        let reqData = LoginRequest(userName: username, password: password)
        guard let jsonPayload = try? JSONEncoder().encode(reqData) else {
            return (false, "Problem building request data")
        }

        guard let url = URL(string: "http://\(host):\(port)/user/login") else {
            return (false, "Couldn't build URL: bad host, port")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: jsonPayload) { data, response, error in
            if let error = error {
                print("Error in upload: \(error)")
                DispatchQueue.main.async {
                    callback(false, "Unknown error")
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...499).contains(response.statusCode) else {
                    DispatchQueue.main.async {
                        callback(false, "Server error")
                    }
                    return
            }
            
            if (200...299).contains(response.statusCode) {
                // TODO: parse response body
                if let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print("Got data: \(dataString)")
                    DispatchQueue.main.async {
                        callback(true, dataString)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        callback(false, "Unknown error")
                    }
                }
            }
            else {
                if let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print("Got data: \(dataString)")
                    DispatchQueue.main.async {
                        callback(false, dataString)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        callback(false, "Unknown error")
                    }
                }

            }
        }
        task.resume()
        return (true, "request accepted")
    }
}
