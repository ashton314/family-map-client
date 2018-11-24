//
//  ViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-23.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginRegisterToggle: UISegmentedControl!

    @IBOutlet weak var loginFormView: UIView!
    @IBOutlet weak var registerFormview: UIView!

    // login fields
    @IBOutlet weak var loginUsername: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginHost: UITextField!
    @IBOutlet weak var loginPort: UITextField!
    
    // register fields
    @IBOutlet weak var registerFirstName: UITextField!
    @IBOutlet weak var registerLastName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerGender: UISegmentedControl!
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerHost: UITextField!
    @IBOutlet weak var registerPort: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func handleLogin(_ sender: Any) {
        let loginData: [String: String?] = ["username": loginUsername.text,
                                            "password": loginPassword.text,
                                            "host": loginHost.text,
                                            "port": loginPort.text];
        handleLoginOrRegister(wasLogin: true, info: loginData)
    }
    @IBAction func handleRegister(_ sender: Any) {
        let registerData: [String: String?] =
            ["username": registerUsername.text, "password": registerPassword.text,
             "host": registerHost.text, "port": registerPort.text,
             "firstname": registerFirstName.text, "lastname": registerLastName.text,
             "email": registerEmail.text,
             "gender": (registerGender.selectedSegmentIndex == 0 ? "m" : "f")]
        handleLoginOrRegister(wasLogin: false, info: registerData)
    }
    @IBAction func toggleLogin(_ sender: Any) {
        switch loginRegisterToggle.selectedSegmentIndex {
        case 0:
            loginFormView.isHidden = false
            registerFormview.isHidden = true
            registerFirstName.setNeedsFocusUpdate()
        case 1:
            loginFormView.isHidden = true
            registerFormview.isHidden = false
            loginUsername.setNeedsFocusUpdate()
        default:
            loginFormView.isHidden = false
            registerFormview.isHidden = true
            loginUsername.setNeedsFocusUpdate()
        }
    }

    func handleLoginOrRegister(wasLogin: Bool, info: [String: String?]) {
        // validate fields
        for (key, val) in info {
            if val == nil || val == "" {
                let alert = UIAlertController(title: "\(wasLogin ? "Login" : "Register") Error", message: "Missing parameter: \(key)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }

        let sp = ServerProxy(host: info["host"]! ?? "", port: info["port"]! ?? "")
        
        let (ok, message) = sp.doLogin(username: info["username"]! ?? "", password: info["password"]! ?? "") { (ok: Bool, message: String) in
            if ok {
                print("Ok: \(message)")
//                let alert = UIAlertController(title: "\(wasLogin ? "Login" : "Register") Success", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default))
//                self.present(alert, animated: true, completion: nil)
            }
            else {
                print("Not OK: \(message)")
//                let alert = UIAlertController(title: "\(wasLogin ? "Login" : "Register") Error", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//                self.present(alert, animated: true, completion: nil)
            }
        }

        if ok {
            print("URL was accepted")
        }
        else {
            let alert = UIAlertController(title: "\(wasLogin ? "Login" : "Register") Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }

    }
}
