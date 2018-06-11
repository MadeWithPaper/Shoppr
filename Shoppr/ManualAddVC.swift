//
//  ManualAddVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ManualAddVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let NUM_ROWS = 100
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countPicker: UIPickerView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var staticSaveButton : UIButton!
    @IBOutlet weak var staticCancelButton: UIButton!
    @IBOutlet weak var itemStoreTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    let blackColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    var itemList = [Item]()
    var masterListRef: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        
        masterListRef = Database.database().reference().child(CurrentUser.getUser().getGroup())
        fetchData()
        
        self.view.backgroundColor = blueColor
        
        self.countPicker.dataSource = self
        self.countPicker.delegate = self
        self.nameTextField.delegate = self
        self.priceTextField.delegate = self
        
        staticSaveButton.layer.borderWidth = 2.0
        staticSaveButton.layer.borderColor = blackColor.cgColor
        staticSaveButton.layer.cornerRadius = 5.0
        staticSaveButton.clipsToBounds = true
        
        staticCancelButton.layer.borderWidth = 2.0
        staticCancelButton.layer.borderColor = blackColor.cgColor
        staticCancelButton.layer.cornerRadius = 5.0
        staticCancelButton.clipsToBounds = true
        
        countPicker.layer.borderWidth = 1.0
        countPicker.layer.borderColor = blackColor.cgColor
        countPicker.layer.cornerRadius = 5.0
        countPicker.clipsToBounds = true
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.delegate = self
        nameTextField.tag = 0
        itemStoreTextField.delegate = self
        itemStoreTextField.tag = 1
        priceTextField.delegate = self
        priceTextField.tag = 2
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fetchData()
    {
        itemList.removeAll()
        masterListRef?.queryOrdered(byChild: CurrentUser.getUser().getGroup()).observe(.value, with:
            { snapshot in
                var newList = [Item]()
                
                for item in snapshot.children {
                    newList.append(Item(snapshot: item as! DataSnapshot))
                }
                
                for itm in newList
                {
                    if (itm.owner == CurrentUser.getUser().getName())
                    {
                        self.itemList.append(itm)
                    }
                }
        })
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NUM_ROWS
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return String(row + 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Move keyobard when edit starts
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != nameTextField && textField != itemStoreTextField
        {
            moveTextField(textField, moveDistance: -200, up: true)
        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != nameTextField && textField != itemStoreTextField
        {
            moveTextField(textField, moveDistance: -200, up: false)
        }
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if textField == priceTextField
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var saved: Item
        
        if(segue.identifier == "saveUnwind") {
            
            guard let amount = priceTextField.text else { return }
            
            var am = Double(amount)
            
            if(priceTextField.text?.isEmpty)! {
                    
                am = walmartAPICall(itemName: self.nameTextField.text!)
            }
            
            let destinationVC = segue.destination as? PersonalTVC

            saved = Item(name: nameTextField.text!, count: countPicker.selectedRow(inComponent: 0) + 1, price: am!, category: "test", key: nameTextField.text!, owner: CurrentUser.getUser().getName(), store: itemStoreTextField.text!)
            if (itemList.contains(saved)) {
                destinationVC?.personalTV.reloadData()
                itemList[(itemList.index(of: saved)!)].count += saved.count
            }
            else
            {
                itemList.append(saved)
            }
            
            destinationVC?.listOfItems = itemList
            updateData()

        }
    }
    func updateData()
    {
        for s in self.itemList
        {
            let item = [
                "Item Name" : s.name as String,
                "Count" : s.count as Int,
                "Price" : s.price as Double,
                "Last Purchased Location" : s.store as String,
                "Category" : s.category as String,
                "Owner" : s.owner as String,
                "Store": s.store as String] as [String : Any]
            self.masterListRef.child(s.name).setValue(item)
        }
    }
}
