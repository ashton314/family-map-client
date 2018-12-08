//
//  SettingsController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-04.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    @IBOutlet weak var mapTypeRadio: UISegmentedControl!

    @IBOutlet weak var lifeLineControllRow: UIView!
    @IBOutlet weak var lifeLineColor: UILabel!
    @IBOutlet weak var lifeLineSwitch: UISwitch!
    @IBOutlet weak var lifeLineColorPicker: UIPickerView!


    @IBOutlet weak var familyTreeColor: UILabel!
    @IBOutlet weak var familyTreeSwitch: UISwitch!
    @IBOutlet weak var familyLineColorPicker: UIPickerView!
    

    @IBOutlet weak var spouseLineColor: UILabel!
    @IBOutlet weak var spouseLineSwitch: UISwitch!
    @IBOutlet weak var spouseLineColorPicker: UIPickerView!
    
    let lifeLineColorPickerPath   = IndexPath(row: 1, section: 1)
    let familyLineColorPickerPath = IndexPath(row: 3, section: 1)
    let spouseLineColorPickerPath = IndexPath(row: 5, section: 1)

    var isLifePickerShown: Bool = false {
        didSet {
            lifeLineColorPicker.isHidden = !isLifePickerShown
        }
    }
    var isFamilyPickerShown: Bool = false {
        didSet {
            familyLineColorPicker.isHidden = !isFamilyPickerShown
        }
    }
    var isSpousePickerShown: Bool = false {
        didSet {
            spouseLineColorPicker.isHidden = !isSpousePickerShown
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (lifeLineColorPickerPath.section, lifeLineColorPickerPath.row): return isLifePickerShown ? 216.0 : 0.0
        default: return 44.0
        }
    }

}
