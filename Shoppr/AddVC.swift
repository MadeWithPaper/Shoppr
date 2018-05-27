//
//  AddVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class AddVC: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var manualView: UIView!
    
    // The segmented controller data has changed
    @IBAction func changeView(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
            // Recipe View is on
            case 0:
                recipeView.isHidden = false
                manualView.isHidden = true
            
            // Manual View is on
            case 1:
                recipeView.isHidden = true
                manualView.isHidden = false
            
            // Shouldn't happen
            default:
                recipeView.isHidden = true
                manualView.isHidden = true
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing the recipe view 
        recipeView.isHidden = false
        manualView.isHidden = true
        
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

}
