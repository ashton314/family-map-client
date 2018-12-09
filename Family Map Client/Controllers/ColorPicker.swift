//
//  ColorPicker.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-08.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class ColorPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    let colors: [String:UIColor] = ["Blue": .blue, "Green": .green, "Red": .red,
                                    "Yellow": .yellow, "Black": .black];
    var selectedCallback: ((Any, Any) -> Void)?

    func setSelectedCallback(_ callback: @escaping (Any, Any) -> Void) {
        self.selectedCallback = callback
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return colors.count
        } else { return 0 }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = colors.keys.sorted()[row]
        print("Selected \(colors[key])")
        if let callback = selectedCallback {
            callback(key, colors[key])
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return colors.keys.sorted()[row]
        } else {
            return "Second \(row)"
        }
    }
}
