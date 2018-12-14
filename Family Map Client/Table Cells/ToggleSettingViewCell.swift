//
//  ToggleSettingViewCell.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-04.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class ToggleSettingViewCell: UITableViewCell {

    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var settingState: UISwitch!

    var setting: SettingToggle?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchToggled(_ sender: Any) {
        self.setting?.state = settingState.isOn
    }

    func update(with setting: SettingToggle) {
        settingName.text = setting.title
        settingState.isOn = setting.state
        self.setting = setting
    }
}
