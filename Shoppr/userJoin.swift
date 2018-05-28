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
    @IBAction func joinButton(_ sender: UIButton) {
       performSegue(withIdentifier: "userJoin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let destVC = segue.destination as! MainTVC
        destVC.userName = "Gaston"
        print("User: \(String(describing: userName.text)) joined, going to master view")
    }
    
    @IBAction func unwindFromMaster(segue:UIStoryboardSegue) {
        print("going from master list view to user join view")
    }

}
