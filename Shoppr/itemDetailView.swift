//
//  itemDetailView.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/27/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class itemDetailView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemCountPV: UIPickerView!
    @IBOutlet weak var itemPriceTF: UITextField!
    @IBOutlet weak var itemLastLocTF: UITextField!
    @IBOutlet weak var itemLastPriceTF: UITextField!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var itemOwnerTF: UITextField!
    
    var item : Item?
    var master : Bool = false
    var parentVC : String!
    var indexOfItem : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cost = Double((item?.count)!) * (item?.price)!
        
        itemOwnerTF.text = "\(String(describing: item!.owner))"
        if master {
            itemOwnerTF.isEnabled = true
        }
        else {
            itemOwnerTF.isEnabled = false
        }
        itemNameTF.text = "\(String(describing: item!.name))"
        itemLastLocTF.text = "\(String(describing: item!.lastPurchaseLocation))"
        itemLastPriceTF.text = "\(item!.lastPurchasePrice)"
        totalCost.text = "Total cost for this item: \(cost)"
        itemPriceTF.text = "\(String(describing: item!.price))"
        itemCountPV.selectRow(((item?.count)!-1), inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO dismiss keyboard as needed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    @IBAction func unwindfromDetail(sender: UIBarButtonItem) {
        if parentVC == "MasterView" {
            self.performSegue(withIdentifier: "unwindFromDetailToMaster", sender: nil)
        }
        else if parentVC == "PersonalView" {
            self.performSegue(withIdentifier: "unwindFromDetailToPersonal", sender: nil)
        }
    }

}
