//
//  itemDetailView.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/27/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class itemDetailView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemCountPV: UIPickerView!
    @IBOutlet weak var itemPriceTF: UITextField!
    @IBOutlet weak var itemStoreTF: UITextField!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var itemOwnerTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    
    var item : Item?
    var master : Bool = false
    var parentVC : String!
    var indexOfItem : IndexPath?
    let MAX_NUM = 100
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.backgroundColor = blueColor
        let cost = Double((item?.count)!) * (item?.price)!
        
        itemOwnerTF.text = "\(String(describing: item!.owner))"
        if master {
            itemOwnerTF.isEnabled = true
        }
        else {
            itemOwnerTF.isEnabled = false
        }
        itemNameTF.text = "\(String(describing: item!.name))"
        itemStoreTF.text = "\(String(describing: item!.store))"
        totalCost.text = "Total cost for this item: \(cost)"
        itemPriceTF.text = "\(String(describing: item!.price))"
        itemCountPV.selectRow(((item?.count)!-1), inComponent: 0, animated: true)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        itemOwnerTF.delegate = self
        itemOwnerTF.tag = 0
        itemNameTF.delegate = self
        itemNameTF.tag = 1
        itemPriceTF.delegate = self
        itemPriceTF.tag = 2
        itemStoreTF.delegate = self
        itemStoreTF.tag = 3
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MAX_NUM;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    @IBAction func unwindfromDetailCancel(sender: UIBarButtonItem) {
        if parentVC == "MasterView" {
            self.performSegue(withIdentifier: "unwindFromDetailToMaster", sender: nil)
        }
        else if parentVC == "PersonalView" {
            self.performSegue(withIdentifier: "unwindFromDetailToPersonal", sender: nil)
        }
    }
    
    @IBAction func unwindFromDetailSave(_ sender: UIBarButtonItem) {
        if parentVC == "MasterView" {
            self.performSegue(withIdentifier: "unwindFromDetailToMasterSave", sender: nil)
        }
        else if parentVC == "PersonalView" {
            self.performSegue(withIdentifier: "unwindFromDetailToPersonalSave", sender: nil)
        }
    }
    
    //Move keyobard when edit starts
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != itemNameTF && textField != itemOwnerTF
        {
            moveTextField(textField, moveDistance: -150, up: true)
        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != itemNameTF && textField != itemOwnerTF
        {
            moveTextField(textField, moveDistance: -150, up: false)
        }
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if textField == itemStoreTF
            {
                dismissKeyboard()
            }
        }
        return false
    }
    
    // Move the text field
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}
