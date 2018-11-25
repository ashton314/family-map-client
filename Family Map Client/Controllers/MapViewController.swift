//
//  MapViewController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-11-24.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    var authToken: String = "";
    var rootPersonID: String = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if authToken == "" {
            performSegue(withIdentifier: "authModal", sender: nil)
        }
    }
    
//    @IBAction func unwindToMap(unwindSeuge: UIStoryboardSegue) {
//        print("Done got unwound to map!")
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
