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
    @IBOutlet weak var itemLastLocTF: UITextField!
    @IBOutlet weak var itemLastPriceTF: UITextField!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var itemOwnerTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var item : Item?
    var master : Bool = false
    var parentVC : String!
    var indexOfItem : IndexPath?
    let MAX_NUM = 100
    
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
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //self.itemLastLocTF.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    /*
    //trying to do scroll view so text fields are not covered by keyboard
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        scrollView?.isScrollEnabled = true
        var info = notification.userInfo!
        if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if let activeField = self.activeField {
                if !aRect.contains(activeField.frame.origin) {
                    self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        var info = notification.userInfo!
        if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize.height, right: 0.0)
            scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
        }
        
        view.endEditing(true)
        scrollView?.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        itemLastLocTF = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        itemLastLocTF = nil
    }*/
    
}
