//
//  userJoin.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class userJoin: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var staticJoinButton: UIButton!
    @IBAction func joinButton(_ sender: UIButton) {
        if (userName.text != "" || groupName.text != "") {
            performSegue(withIdentifier: "userJoin", sender: self)
            print("not nil")
        }
        else {
            let alert = UIAlertController(title: "Empty fields", message: "Please enter a Name and a Group", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                NSLog("User dismissed alert")
            }
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion:nil)
        }
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destVC = segue.destination as! MainTVC
        CurrentUser.getUser().setName(newName: userName.text!)
        CurrentUser.getUser().setGroup(newGroup: groupName.text!)
    }
    
    @IBAction func unwindFromMaster(segue:UIStoryboardSegue) {
        print("going from master list view to user join view")
    }

}
