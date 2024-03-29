//
//  userJoin.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class userJoin: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var staticJoinButton: UIButton!
    @IBAction func joinButton(_ sender: UIButton) {
        signInCheck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
        let blackColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        view.backgroundColor = blueColor
        
        //static UI change
        staticJoinButton.layer.borderWidth = 2.0
        staticJoinButton.layer.borderColor = blackColor.cgColor
        staticJoinButton.layer.cornerRadius = 5.0
        staticJoinButton.clipsToBounds = true
        
        userName.layer.borderWidth = 2.0
        userName.layer.borderColor = blackColor.cgColor
        userName.layer.cornerRadius = 5.0
        userName.clipsToBounds = true
        
        
        groupName.layer.borderWidth = 2.0
        groupName.layer.borderColor = blackColor.cgColor
        groupName.layer.cornerRadius = 5.0
        groupName.clipsToBounds = true

        userName.delegate = self
        userName.tag = 0
        groupName.delegate = self
        groupName.tag = 1
        
        //dismiss keyboard on tap outside of text field
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Move keyobard when edit starts
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -150, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -150, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if textField == groupName
            {
                signInCheck()
            }
        }
        return false
    }
    
    static func checkName(s: String) -> Bool{
        return s.contains("$") || s.contains("[") || s.contains("]") || s.contains("#") || s.contains(".")
    }
    
    func signInCheck()
    {
        if (userName.text != "" && groupName.text != "" && !userJoin.checkName(s: groupName.text!)) {
            if(groupName.text == "Recipe") {
                groupName.text = "_Recipe"
            }
            performSegue(withIdentifier: "userJoin", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "Empty fields", message: "Please enter a Name and a Group. Notes: Group Name cannot contain \'#\', \'$\', \'[\', \']\', or \'.\'",  preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                NSLog("User dismissed alert")
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion:nil)
        }
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
        CurrentUser.getUser().setName(newName: userName.text!)
        CurrentUser.getUser().setGroup(newGroup: groupName.text!)
        print(CurrentUser.getUser().getName())
    }
    
    @IBAction func unwindFromMaster(segue:UIStoryboardSegue) {
        self.userName.text = ""
        self.groupName.text = ""
    }

}
