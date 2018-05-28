//
//  ManualAddVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class ManualAddVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let NUM_ROWS = 100
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countPicker: UIPickerView!
    @IBOutlet weak var priceTextField: UITextField!
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = blueColor
        
        self.countPicker.dataSource = self
        self.countPicker.delegate = self
        self.nameTextField.delegate = self
        self.priceTextField.delegate = self
        
        // Do any additional setup after loading the view.
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var saved: Item
        // TODO: Save/ Pass the data to the personal list
        
        if(segue.identifier == "saveUnwind") {
            print("I need to pass the data back")
            
            guard let amount = priceTextField.text else { return }
            
            // Now you can use amount anywhere but if it's nil, it will return.
            let am = Double(amount) // for instance
            
            saved = Item(name: nameTextField.text!, count: countPicker.selectedRow(inComponent: 0) + 1, price: am!, LPL: "PlaceHolder", LPP: 0.0, category: "test", key: nameTextField.text!, owner: "Gaston")
            
            let destinationVC = segue.destination as? PersonalTVC
            
            print(saved)
            
            destinationVC?.itemSaved = saved
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
