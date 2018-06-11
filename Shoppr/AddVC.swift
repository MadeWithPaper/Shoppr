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
    var itemList = [Item]()
    // The segmented controller data has changed
    @IBAction func updatedView(_ sender: UISegmentedControl) {
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
