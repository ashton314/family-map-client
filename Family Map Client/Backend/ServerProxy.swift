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
                let jsonDecoder = JSONDecoder()
                if let data = data,
                    let dataString = String(data: data, encoding: .utf8),
                    let response = try? jsonDecoder.decode([String: String].self, from: data) {
                    print("Raw response: \(dataString)")
                    DispatchQueue.main.async {
                        callback(false, response["message"] ?? "Bad response from server")
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

    func doRegister(username: String, password: String, email: String, firstname: String, lastname: String, gender: String,
                    callback: @escaping (Bool, String) -> Void) -> (Bool, String) {
        
        struct RegisterRequest: Codable {
            let userName: String
            let password: String
            let email: String
            let firstName: String
            let lastName: String
            let gender: String
        }
        
        let reqData = RegisterRequest(userName: username, password: password,
                                      email: email, firstName: firstname, lastName: lastname, gender: gender)
        guard let jsonPayload = try? JSONEncoder().encode(reqData) else {
            return (false, "Problem building request data")
        }
        
        guard let url = URL(string: "http://\(host):\(port)/user/register") else {
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
                let jsonDecoder = JSONDecoder()
                if let data = data,
                   let dataString = String(data: data, encoding: .utf8),
                    let response = try? jsonDecoder.decode([String: String].self, from: data) {
                    print("Raw response: \(dataString)")
                    DispatchQueue.main.async {
                        callback(false, response["message"] ?? "Bad response from server")
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
