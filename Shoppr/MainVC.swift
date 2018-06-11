//
//  MainTVC.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMobileVision

class MainTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var masterListTV: UITableView!
    var parsed = [VisionText]()
    var listOfItems  = [Item]()
    var userItemList = [Item]()
    var masterListRef: DatabaseReference!
    lazy var vision = Vision.vision()
    var textDetector : VisionTextDetector?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCostText: UITextField?
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    let whileColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    let blackColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)

    @IBAction func personalListButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PersonalListSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalCostText?.isUserInteractionEnabled = false
        tableView.backgroundColor = blueColor

        //Firebase database reference
        masterListRef = Database.database().reference().child(CurrentUser.getUser().getGroup())
        
        fetchData()
        
        calcTotalCost()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = blueColor
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(listOfItems[(indexPath.row)].name).removeValue()
            listOfItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async(){
            self.masterListTV.reloadData()
        }
        calcTotalCost()
    }
    
    //fetch for firebase data
    func fetchData() {
        listOfItems.removeAll()
        userItemList.removeAll()
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
                        self.userItemList.append(itm)
                    }
                }
                self.listOfItems = newList
            
                DispatchQueue.main.async(){
                     self.masterListTV.reloadData()
                    self.calcTotalCost()
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PersonalListSegue") {
            let destVC = segue.destination as! PersonalTVC
            //destVC.masterListRef = masterListRef
            destVC.listOfItems.removeAll()
            userItemList.removeAll()
            for itm in listOfItems
            {
                if (itm.owner == CurrentUser.getUser().getName())
                {
                    self.userItemList.append(itm)
                }
            }
            destVC.listOfItems = userItemList
            print("going to \(String(describing: CurrentUser.getUser().getName()))'s detail list view")
        }
        else if (segue.identifier == "masterItemDetail") {
            if let indexPath = masterListTV.indexPathForSelectedRow {
                let object = listOfItems[(indexPath as NSIndexPath).row]
                let destVC = segue.destination as! itemDetailView
                destVC.parentVC = "MasterView"
                destVC.item = object
                destVC.master = true
                destVC.indexOfItem = indexPath
                print("going to item detail view from master")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainItemCell", for: indexPath) as! ItemCell
        
        let object = listOfItems[(indexPath as NSIndexPath).row]
        cell.itemNameLabel.text = object.name
        cell.itemCountLabel.text = " X\(object.count)"
        cell.itemPriceLabel.text = "$\(object.price)"
        cell.lastLocAndPriceLabel.text = "Store: \(object.store)"
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.3
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.borderColor = whileColor.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "masterItemDetail", sender: self)
    }
    
    @IBAction func unwindFromDetailToMaster(storyboard: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindFromCameraToMaster(segue: UIStoryboardSegue){
        // TODO
        
        print("IN UNWIND")
        
        for feature in self.parsed {
            
            let value = feature.text
            print("VALUE: \(value)")
            //let corners = feature.cornerPoints
            var i = 0
            
            for itm in self.listOfItems {
                
                if  itm.name.contains(value.lowercased()){
                    masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(itm.name).removeValue()
                    print("\(value) removed")
                    self.listOfItems.remove(at: i)
                }
                i = i+1
            }
            
            //print(value)
        }
    }
    
    @IBAction func unwindFromDetailToMasterSave(storyboard: UIStoryboardSegue) {
        let srcVC = storyboard.source as! itemDetailView
        let oldName = (listOfItems[srcVC.indexOfItem!.row]).name
        let itemOwner = srcVC.itemOwnerTF.text
        let itemName = srcVC.itemNameTF.text
        let itemCount = srcVC.itemCountPV.selectedRow(inComponent: 0)+1
        //let itemPrice = srcVC.itemLastPriceTF.text!
        //let itemLL = srcVC.itemStoreTF.text
        //let itemLP = srcVC.itemLastPriceTF.text!
        let itemCate = srcVC.item?.category
        let itemStore = srcVC.itemStoreTF.text!
        listOfItems[srcVC.indexOfItem!.row] = (Item(name: itemName!, count: Int(itemCount), price: Double(srcVC.itemPriceTF.text!)!, /*LPL: itemLL!, LPP: Double(srcVC.itemLastPriceTF.text!)!,*/ category: itemCate!, key: itemName!, owner: itemOwner!, store: itemStore))

        updateData(item: listOfItems[srcVC.indexOfItem!.row], old: oldName)
    }
    
    func updateData(item: Item, old: String) {
        masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(old).removeValue()
        masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(item.name).setValue(item.toAnyObject())
        DispatchQueue.main.async(){
            self.masterListTV.reloadData()
            self.calcTotalCost()
        }
    }
    
    @IBAction func unwindFromPersonalToMaster(segue:UIStoryboardSegue){
        let srcVC = segue.source as! PersonalTVC
        /*for items in srcVC.listOfItems {
            if (!self.listOfItems.contains(items)) {
                self.listOfItems.append(items)
            }
            ind += 1
        }*/
    
        for itm in srcVC.listOfItems {
        
            masterListRef.observeSingleEvent(of: .value, with: {(snapshot) in
                //database contains this item, update values
                if snapshot.hasChild(itm.name)
                {
                    print("contains item")
                    self.masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(itm.name).setValue(itm.toAnyObject())
                }
                //database does not contain this item, adding to it
                else
                {
                    print("adding new items")
                    let item = [
                        "Item Name" : itm.name as String,
                        "Count" : itm.count as Int,
                        "Price" : itm.price as Double,
                        "Store" : itm.store as String,
                        //"Last Purchased Price" : itm.lastPurchasePrice as Double,
                        "Category" : itm.category as String,
                        "Owner" : itm.owner as String] as [String : Any]
                    self.masterListRef.child(itm.name).setValue(item)
                }
            })
        }
        fetchData()
    }
    
    func calcTotalCost()
    {
        var temp = 0.0
        for item in listOfItems
        {
            temp += ((Double(item.count) * item.price))
        }
        
        totalCostText?.text = "Total Cost: $\(temp)"
    }
   /* func testingInit() {
        // Test item and one time init for testing
        listOfItems.append(Item(name: "apples", count: 1, price: 1.00, LPL: "target", LPP: 0.98, category: "furit", key: "apples", owner: "Jacky"))
        listOfItems.append(Item(name: "oranges", count: 2, price: 1.00, LPL: "safeway", LPP: 0.98, category: "furit", key: "oranges", owner: "Jacky"))
        listOfItems.append(Item(name: "pear", count: 2, price: 1.00, LPL: "safeway", LPP: 0.98, category: "furit", key: "oranges", owner: "Gaston"))
        listOfItems.append(Item(name: "onion", count: 2, price: 1.00, LPL: "safeway", LPP: 0.98, category: "furit", key: "oranges", owner: "Gaston"))
        
        for s in self.listOfItems
        {
            let item = [
                "Item Name" : s.name as String,
                "Count" : s.count as Int,
                "Price" : s.price as Double,
                "Last Purchased Location" : s.lastPurchaseLocation as String,
                "Last Purchased Price" : s.lastPurchasePrice as Double,
                "Category" : s.category as String,
                "Owner" : s.owner as String] as [String : Any]
            self.masterListRef.child(s.name).setValue(item)
        }
        
        listOfItems.removeAll()
    }*/
}

