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

    func getPeople(authToken: String, callback: @escaping (Bool, Any) -> Void) -> (Bool, String) {
        guard let url = URL(string: "http://\(host):\(port)/person") else {
            return (false, "Couldn't build URL: bad host, port")
        }
        
        var request = URLRequest(url: url)
        request.addValue(authToken, forHTTPHeaderField: "authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in fetching people: \(error)")
                DispatchQueue.main.async {
                    callback(false, "Error: \(error.localizedDescription)")
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
            
            if (200...299).contains(response.statusCode) {  // got good response
                let decoder = JSONDecoder()
                let debugString = data != nil ? (String(data: data as! Data, encoding: .utf8) ?? "") : ""
                if let data = data,
                   let decoded = try? decoder.decode([String: [Person]].self, from: data),
                   let people = decoded["data"] {
                    print("successfully got a bunch of people!")
                    DispatchQueue.main.async {
                        callback(true, people)
                        return
                    }
                }
                else {
                    DispatchQueue.main.async {
                        print("failed parsing data")
                        callback(false, "couldn't parse \(debugString)")
                    }
                }
            }
            else {  // got bad response
                let decoder = JSONDecoder()
                if let data = data,
                    let decoded = try? decoder.decode([String:String].self, from: data) {
                    DispatchQueue.main.async {
                        callback(false, "Error: \(decoded["message"] ?? "Unknown error")")
                        return
                    }
                }
            }
            //            callback(false, "Unable to parse response")
        }
        task.resume()
        return (true, "request successful")
    }

    func getEvents(authToken: String, callback: @escaping (Bool, Any) -> Void) -> (Bool, String) {
        guard let url = URL(string: "http://\(host):\(port)/event") else {
            return (false, "Couldn't build URL: bad host, port")
        }
        
        var request = URLRequest(url: url)
        request.addValue(authToken, forHTTPHeaderField: "authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in fetching people: \(error)")
                DispatchQueue.main.async {
                    callback(false, "Error: \(error.localizedDescription)")
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
            
            if (200...299).contains(response.statusCode) {  // got good response
                let decoder = JSONDecoder()
                let debugString = data != nil ? (String(data: data as! Data, encoding: .utf8) ?? "") : ""
                if let data = data,
                   let decoded = try? decoder.decode([String: [Event]].self, from: data),
                   let events = decoded["data"] {
                    DispatchQueue.main.async {
                        callback(true, events)
                        return
                    }
                }
                else {
                    callback(false, "error parsing \(debugString)")
                }
            }
            else {  // got bad response
                let decoder = JSONDecoder()
                if let data = data,
                    let decoded = try? decoder.decode([String:String].self, from: data) {
                    DispatchQueue.main.async {
                        callback(false, "Error: \(decoded["message"] ?? "Unknown error")")
                        return
                    }
                }
            }
            //            callback(false, "Unable to parse response")
        }
        task.resume()
        return (true, "request successful")
    }
    
    func getPerson(authToken: String, personID: String, callback: @escaping (Bool, Any) -> Void) -> (Bool, String) {
        guard let url = URL(string: "http://\(host):\(port)/person/\(personID)") else {
            return (false, "Couldn't build URL: bad host, port, personID")
        }

        var request = URLRequest(url: url)
        request.addValue(authToken, forHTTPHeaderField: "authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in fetching people: \(error)")
                DispatchQueue.main.async {
                    callback(false, "Error: \(error.localizedDescription)")
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

            if (200...299).contains(response.statusCode) {  // got good response
                let decoder = JSONDecoder()
                if let data = data,
                   let decoded = try? decoder.decode(Person.self, from: data) {
                    DispatchQueue.main.async {
                        callback(true, decoded)
                        return
                    }
                }
            }
            else {  // got bad response
                let decoder = JSONDecoder()
                if let data = data,
                   let decoded = try? decoder.decode([String:String].self, from: data) {
                    DispatchQueue.main.async {
                        callback(false, "Error: \(decoded["message"] ?? "Unknown error")")
                        return
                    }
                }
            }
//            callback(false, "Unable to parse response")
        }
        task.resume()
        return (true, "request successful")
    }

    func doLogin(username: String, password: String, callback: @escaping (Bool, [String:String]) -> Void) -> (Bool, String) {

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
            self.loginOrRegister(data: data, response: response, error: error, callback: callback) }
        task.resume()
        return (true, "request accepted")
    }

    func doRegister(username: String, password: String, email: String, firstname: String, lastname: String, gender: String,
                    callback: @escaping (Bool, [String:String]) -> Void) -> (Bool, String) {
        
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
            self.loginOrRegister(data: data, response: response, error: error, callback: callback) }
        task.resume()
        return (true, "request accepted")
    }

    func loginOrRegister(data: Data?, response: URLResponse?, error: Error?, callback: @escaping (Bool, [String: String]) -> Void) {
        if let error = error {
            print("Error in upload: \(error)")
            DispatchQueue.main.async {
                callback(false, ["message": "Error: \(error.localizedDescription)"])
            }
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...499).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    callback(false, ["message": "Server error"])
                }
                return
        }
        
        if (200...299).contains(response.statusCode) {
            let decoder = JSONDecoder()
            if let data = data,
                let dataString = String(data: data, encoding: .utf8),
                let decoded = try? decoder.decode([String: String].self, from: data) {
                print("Raw response: \(dataString) (tag: 1)")
                DispatchQueue.main.async {
                    callback(true, decoded)
                }
            }
            else {
                DispatchQueue.main.async {
                    callback(false, ["message": "Unknown error"])
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
                    callback(false, ["message": response["message"] ?? "Bad response from server"])
                }
            }
            else {
                DispatchQueue.main.async {
                    callback(false, ["message": "Unknown error"])
                }
            }
            
        }
    }

}
