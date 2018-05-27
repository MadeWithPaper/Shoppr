//
//  itemDetailView.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/27/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class itemDetailView: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemCostLabel: UILabel!
    @IBOutlet weak var lastText: UITextView!
    
    var item : Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cost = Double((item?.count)!) * (item?.price)!
        
        itemNameLabel.text = item?.name
        lastText.text = "Last Purchased at \(String(describing: item!.lastPurchaseLocation)) for $\(String(describing: item!.lastPurchasePrice))"
        itemCostLabel.text = "Cost: \(String(describing: item!.count)) X $\(String(describing: item!.price)) = \(cost)"
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
