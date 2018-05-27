//
//  RecipeVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class RecipeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: Save/ Pass the data to the personal list
        
        if(segue.identifier == "saveUnwind") {
            print("AHHHHHH")
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
