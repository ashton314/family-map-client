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
    
}

