//
//  FamilyMemberCell.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-11.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit

class FamilyMemberCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    
    var basePerson: Person?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateFrom(person: Person, relation: String) {
        self.nameLabel.text = person.fullName()
        self.relationLabel.text = relation
        self.basePerson = person
    }
}
