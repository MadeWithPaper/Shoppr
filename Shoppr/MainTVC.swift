//
//  MainTVC.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var listOfItems  = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfItems.append(Item(name: "apples", count: 1, price: 1.00, LPL: "target", LPP: 0.98, category: "furit", key: "testing"))
        
        print("Testing")
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailViewSegue") {
            // TODO
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        // Unwinding here
    }
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        
        switch gestureRecognizer.direction {
        case UISwipeGestureRecognizerDirection.up:
            print("Swipped Up")
            takePhoto()
        case UISwipeGestureRecognizerDirection.left:
            print("Swipped Left")
            performSegue(withIdentifier: "DetailViewSegue", sender: self)
        default:
            print("Default")
        }
    }
    
    @IBAction func takePhoto() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        // default to photo library if camera unavailable
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        
        present(picker, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainItemCell", for: indexPath) as! ItemCell
        
        let object = listOfItems[(indexPath as NSIndexPath).row]
        cell.itemNameLabel.text = object.name
        cell.itemCountLabel.text = String(object.count)
        cell.itemPriceCount.text = String(object.price)
        cell.lastLocAndPriceLabel.text = "Last purchased at \(object.lastPurchaseLocation) at \(object.lastPurchasePrice)"
        
        
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func unwindFromDetail(segue:UIStoryboardSegue) {
        
    }
    
}

