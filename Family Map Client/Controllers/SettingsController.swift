//
//  SettingsController.swift
//  Family Map Client
//
//  Created by Ashton Wiersdorf on 2018-12-04.
//  Copyright © 2018 Ashton Wiersdorf. All rights reserved.
//

import UIKit
import MapKit

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
    
    var store: MemoryStore?

    let lifeLineColorPickerPath   = IndexPath(row: 1, section: 1)
    let familyLineColorPickerPath = IndexPath(row: 3, section: 1)
    let spouseLineColorPickerPath = IndexPath(row: 5, section: 1)

    // These variables enable the accordion-like behavior
    var isLifePickerShown: Bool = false {
        didSet {
            lifeLineColorPicker.isHidden = !isLifePickerShown
            if isLifePickerShown {
                isFamilyPickerShown = false
                isSpousePickerShown = false
            }
        }
    }
    var isFamilyPickerShown: Bool = false {
        didSet {
            familyLineColorPicker.isHidden = !isFamilyPickerShown
            if isFamilyPickerShown {
                isLifePickerShown = false
                isSpousePickerShown = false
            }
        }
    }
    var isSpousePickerShown: Bool = false {
        didSet {
            spouseLineColorPicker.isHidden = !isSpousePickerShown
            if isSpousePickerShown {
                isLifePickerShown = false
                isFamilyPickerShown = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let store = store else { return }

        lifeLineColor.text = ColorPicker.humanizeColor(store.lifeLineColor)
        familyTreeColor.text = ColorPicker.humanizeColor(store.familyLineColor)
        spouseLineColor.text = ColorPicker.humanizeColor(store.spouseLineColor)

        lifeLineSwitch.isOn = store.showLifeLine
        familyTreeSwitch.isOn = store.showFamilyLine
        spouseLineSwitch.isOn = store.showSpouseLine

        let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
        mapTypeRadio.selectedSegmentIndex = mapTypes.firstIndex(of: store.mapType)!

        let lifeLineColorPicker = self.lifeLineColorPicker as! ColorPicker
        lifeLineColorPicker.delegate = lifeLineColorPicker
        lifeLineColorPicker.dataSource = lifeLineColorPicker
        lifeLineColorPicker.setSelectedCallback({ (name, color) in self.lifeLineColor.text = name as? String; self.store?.lifeLineColor = color as! UIColor })

        let familyLineColorPicker = self.familyLineColorPicker as! ColorPicker
        familyLineColorPicker.delegate = familyLineColorPicker
        familyLineColorPicker.dataSource = familyLineColorPicker
        familyLineColorPicker.setSelectedCallback({ (name, color) in self.familyTreeColor.text = name as? String; self.store?.familyLineColor = color as! UIColor })

        let spouseLineColorPicker = self.spouseLineColorPicker as! ColorPicker
        spouseLineColorPicker.delegate = spouseLineColorPicker
        spouseLineColorPicker.dataSource = spouseLineColorPicker
        spouseLineColorPicker.setSelectedCallback({ (name, color) in self.spouseLineColor.text = name as? String; self.store?.spouseLineColor = color as! UIColor })
    }

    // These methods make it possible to collapse the picker wheels when not in use
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (lifeLineColorPickerPath.section, lifeLineColorPickerPath.row): return isLifePickerShown ? 216.0 : 0.0
        case (familyLineColorPickerPath.section, familyLineColorPickerPath.row): return isFamilyPickerShown ? 216.0 : 0.0
        case (spouseLineColorPickerPath.section, spouseLineColorPickerPath.row): return isSpousePickerShown ? 216.0 : 0.0
        default: return 44.0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (lifeLineColorPickerPath.section, lifeLineColorPickerPath.row - 1):
            isLifePickerShown = !isLifePickerShown
            tableView.beginUpdates()
            tableView.endUpdates()
        case (familyLineColorPickerPath.section, familyLineColorPickerPath.row - 1):
            isFamilyPickerShown = !isFamilyPickerShown
            tableView.beginUpdates()
            tableView.endUpdates()
        case (spouseLineColorPickerPath.section, spouseLineColorPickerPath.row - 1):
            isSpousePickerShown = !isSpousePickerShown
            tableView.beginUpdates()
            tableView.endUpdates()
        default: break
        }
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        guard let store = store else { return }
        let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
        store.mapType = mapTypes[sender.selectedSegmentIndex]
    }

    @IBAction func resyncData(_ sender: Any) {
    }
    @IBAction func logOut(_ sender: Any) {
    }
    
    @IBAction func toggleLifeLine(_ sender: UISwitch) {
        guard let store = store else { return }
        store.showLifeLine = sender.isOn
    }
    @IBAction func toggleFamilyLine(_ sender: UISwitch) {
        guard let store = store else { return }
        store.showFamilyLine = sender.isOn
    }
    @IBAction func toggleSpouseLine(_ sender: UISwitch) {
        guard let store = store else { return }
        store.showSpouseLine = sender.isOn
    }
}
