//
//  ViewController.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PersonalTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var personalTV: UITableView!
    
    @IBOutlet weak var personalNaviBar: UINavigationBar!
    var listOfItems  = [Item]()
    var savedReceipes = [SRRecipe?]()
    var itemSaved: Item?
    var masterListRef: DatabaseReference!
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    let whileColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    @IBOutlet weak var totalCostText: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalTV.backgroundColor = blueColor
        personalNaviBar.topItem?.title = "\(CurrentUser.getUser().getName())'s Inventory"
        
        //fetchData()
        calcTotalCost()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        personalTV.reloadData()
        calcTotalCost()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = blueColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalItemCell", for: indexPath) as! ItemCell
        
        let object = listOfItems[(indexPath as NSIndexPath).row]
        cell.itemNameLabel.text = object.name
        cell.itemCountLabel.text = String(describing: object.count)
        cell.itemPriceLabel.text = String(describing: object.price)
        cell.lastLocAndPriceLabel.text = "Last purchased at \(String(describing: object.lastPurchaseLocation)) for $\(String(describing: object.lastPurchasePrice))"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "personalItemDetail", sender: self)
    }
    
    @IBAction func cancelUnwind(segue:UIStoryboardSegue) {
        print("cancelUnwind")
    }
    
    @IBAction func saveUnwind(segue:UIStoryboardSegue) {
        print("saveUnwind")
        if(itemSaved != nil) {
            listOfItems.append(itemSaved!)
            personalTV.reloadData()
            updateData()
            //CurrentUser.getUser().setInventory(newInventory: listOfItems)
        }
    }
    
    @IBAction func unwindFromSavedRecipesVC(segue:UIStoryboardSegue){
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(listOfItems[indexPath.row].name).removeValue()
            listOfItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func updateData() {
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
        calcTotalCost()
        //CurrentUser.getUser().setInventory(newInventory: listOfItems)
    }
    /*
    func fetchData() {
        listOfItems.removeAll()
        masterListRef?.queryOrdered(byChild: CurrentUser.getUser().getGroup()).observe(.value, with:
            { snapshot in
                var newList = [Item]()
                for item in snapshot.children {
                    let newItem = Item(snapshot: item as! DataSnapshot)
                    if (newItem.owner == CurrentUser.getUser().getName()) {
                        newList.append(newItem)
                    }
                }
                
                self.listOfItems = newList
                CurrentUser.getUser().setInventory(newInventory: newList)
                self.personalTV.reloadData()
        })
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "personalItemDetail") {
            if let indexPath = personalTV.indexPathForSelectedRow {
                let object = listOfItems[(indexPath as NSIndexPath).row]
                let destVC = segue.destination as! itemDetailView
                destVC.item = object
                destVC.master = false
                destVC.indexOfItem = indexPath
                destVC.parentVC = "PersonalView"
                print("going to item detail view from personal")
            }
        }
    }
    
    @IBAction func unwindFromDetailToPersonal(storyboard: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindFromDetailToPersonalSave(storyboard: UIStoryboardSegue) {
        let srcVC = storyboard.source as! itemDetailView
        let oldName = (listOfItems[srcVC.indexOfItem!.row]).name
        let itemOwner = srcVC.itemOwnerTF.text
        let itemName = srcVC.itemNameTF.text
        let itemCount = srcVC.itemCountPV.selectedRow(inComponent: 0)+1
       // let itemPrice = srcVC.itemLastPriceTF.text!
        let itemLL = srcVC.itemLastLocTF.text
       // let itemLP = srcVC.itemLastPriceTF.text!
        let itemCate = srcVC.item?.category
        
        //print(srcVC.itemPriceTF.text!)
        listOfItems[srcVC.indexOfItem!.row] = (Item(name: itemName!, count: Int(itemCount), price: Double(srcVC.itemPriceTF.text!)!, LPL: itemLL!, LPP: Double(srcVC.itemLastPriceTF.text!)!, category: itemCate!, key: itemName!, owner: itemOwner!))
        
        updateItem(item: listOfItems[srcVC.indexOfItem!.row], old: oldName)
    }
    
    func updateItem(item: Item, old: String) {
        masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(old).removeValue()
        masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(item.name).setValue(item.toAnyObject())
        DispatchQueue.main.async(){
            self.personalTV.reloadData()
            self.calcTotalCost()
        }
    }
    
    func calcTotalCost()
    {
        var temp = 0.0
        for item in listOfItems
        {
            temp += ((Double(item.count) * item.price))
        }
        
        totalCostText?.text = String(temp)
    }
}


