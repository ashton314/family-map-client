//
//  FilterViewCell.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-12.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class FilterViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    

    var setter: (Bool) -> () = { _ in }
    var getter: () -> Bool = { false }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(title: String, withSetter: @escaping (Bool) -> (), withGetter: @escaping () -> Bool) {
        self.title.text = title
        setter = withSetter
        getter = withGetter
        self.filterSwitch.isOn = getter()
    }

    @IBAction func onToggle(_ sender: UISwitch) {
        self.setter(sender.isOn)
    }
}
