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

        lifeLineColor.text = ColorPicker.humanizeColor(store.getLifeLineColor())
        familyTreeColor.text = ColorPicker.humanizeColor(store.getFamilyLineColor())
        spouseLineColor.text = ColorPicker.humanizeColor(store.getSpouseLineColor())

        lifeLineSwitch.isOn = store.getShowLifeLine()
        familyTreeSwitch.isOn = store.getShowFamilyLine()
        spouseLineSwitch.isOn = store.getShowSpouseLine()

        let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
        mapTypeRadio.selectedSegmentIndex = mapTypes.firstIndex(of: store.getMapType())!

        let lifeLineColorPicker = self.lifeLineColorPicker as! ColorPicker
        lifeLineColorPicker.delegate = lifeLineColorPicker
        lifeLineColorPicker.dataSource = lifeLineColorPicker
        lifeLineColorPicker.setSelectedCallback({ (name, color) in self.lifeLineColor.text = name as? String; self.store?.setLifeLineColor(color as! UIColor) })

        let familyLineColorPicker = self.familyLineColorPicker as! ColorPicker
        familyLineColorPicker.delegate = familyLineColorPicker
        familyLineColorPicker.dataSource = familyLineColorPicker
        familyLineColorPicker.setSelectedCallback({ (name, color) in self.familyTreeColor.text = name as? String; self.store?.setFamilyLineColor(color as! UIColor) })

        let spouseLineColorPicker = self.spouseLineColorPicker as! ColorPicker
        spouseLineColorPicker.delegate = spouseLineColorPicker
        spouseLineColorPicker.dataSource = spouseLineColorPicker
        spouseLineColorPicker.setSelectedCallback({ (name, color) in self.spouseLineColor.text = name as? String; self.store?.setSpouseLineColor(color as! UIColor) })
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
        store.setMapType(mapTypes[sender.selectedSegmentIndex])
    }

    @IBAction func resyncData(_ sender: Any) {
        guard let store = store else { return }
        let (ok, message) = store.refreshPeople()
        if !ok {
            print("Problem updating list of people: \(message)")
            doAlert("Error", message: "Problem fetching people: \(message)")
        } else { print("refreshing people seems alright") }
        let (ok2, message2) = store.refreshEvents() {
            (ok, resp) in
            if ok {
                print("everything good here")
                self.performSegue(withIdentifier: "unwindToMap", sender: nil)
            }
            else {
                print(resp)
                self.doAlert("Error", message: "Problem fetching events: \(resp)")
            }
        }
        if !ok2 {
            doAlert("Error", message: "Problem fetching events: \(message2)")
        }
    }
    @IBAction func logOut(_ sender: Any) {
        store = nil
        self.performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
    
    @IBAction func toggleLifeLine(_ sender: UISwitch) {
        guard let store = store else { return }
        store.setShowLifeLine(sender.isOn)
    }
    @IBAction func toggleFamilyLine(_ sender: UISwitch) {
        guard let store = store else { return }
        store.setShowFamilyLine(sender.isOn)
    }
    @IBAction func toggleSpouseLine(_ sender: UISwitch) {
        guard let store = store else { return }
        store.setShowSpouseLine(sender.isOn)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: MapViewController.self) {
            let dest = segue.destination as! MapViewController
            dest.store = store
        }
    }

    func doAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
