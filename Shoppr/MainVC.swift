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
    
    var listOfItems  = [Item]()
    //var userList = [Item]()
    var masterListRef: DatabaseReference!
    lazy var vision = Vision.vision()
    var textDetector : VisionTextDetector?
    @IBOutlet weak var tableView: UITableView!

    
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    let whileColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    @IBAction func personalListButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PersonalListSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = blueColor

        //Firebase database reference
        masterListRef = Database.database().reference().child(CurrentUser.getUser().getGroup())
        
        //testing function
        //testingInit()
        
        fetchData()
        //image scanning
        textDetector = vision.textDetector()
        
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        navigationItem.leftBarButtonItem = camera
        
        // Defining a SwipeLeft Gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = blueColor
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            listOfItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        masterListTV.reloadData()
    }
    
    //fetch for firebase data
    func fetchData() {
        listOfItems.removeAll()
        masterListRef?.queryOrdered(byChild: "Master List").observe(.value, with:
            { snapshot in
                var newList = [Item]()
                
                for item in snapshot.children {
                    newList.append(Item(snapshot: item as! DataSnapshot))
                }
                
                self.listOfItems = newList
                self.masterListTV.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PersonalListSegue") {
            let destVC = segue.destination as! PersonalTVC
            var userList = [Item]()
            for i in listOfItems {
                if i.owner == CurrentUser.getUser().getName() {
                    userList.append(i)
                }
            }
            //destVC.currUser = curUser
            destVC.listOfItems = userList
            destVC.masterListRef = masterListRef
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
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
//
//        switch gestureRecognizer.direction {
//        case UISwipeGestureRecognizerDirection.left:
//            print("Swipped Left")
//            performSegue(withIdentifier: "PersonalListSegue", sender: self)
//        default:
//            print("Default")
//        }
    }
    
    @IBAction func takePhoto() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        // default to photo library if camera unavailable
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        
        present(picker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image = VisionImage(image: pickedImage)
            
            textDetector?.detect(in: image) { (features, error) in
                guard error == nil, let features = features, !features.isEmpty else {
                    // Error. You should also check the console for error messages.
                    // ...
                    return
                }
                
                // Recognized and extracted text
                print("Detected text has: \(features.count) blocks")
                // ...
                
                
                print("PARSING")
                
                for feature in features {
                    let value = feature.text
                    //let corners = feature.cornerPoints
                    var i = 0
                    
                    for itm in self.listOfItems {
                        
                        if value.lowercased() == itm.name.lowercased() {
                            print("\(value) removed")
                            self.listOfItems.remove(at: i)
                        }
                        i = i+1
                    }
                    
                    //print(value)
                }
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainItemCell", for: indexPath) as! ItemCell
        
        let object = listOfItems[(indexPath as NSIndexPath).row]
        cell.itemNameLabel.text = object.name
        cell.itemCountLabel.text = " X\(object.count)"
        cell.itemPriceLabel.text = "$\(object.price)"
        cell.lastLocAndPriceLabel.text = "Last purchased at \(object.lastPurchaseLocation) for $\(object.lastPurchasePrice)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "masterItemDetail", sender: self)
    }
    
    @IBAction func unwindFromDetailToMaster(storyboard: UIStoryboardSegue){
        
    }
    @IBAction func unwindFromDetailToMasterSave(segue:UIStoryboardSegue) {
        let srcVC = segue.source as! itemDetailView
        let oldName = (listOfItems[srcVC.indexOfItem!.row]).name
        let itemOwner = srcVC.itemOwnerTF.text
        let itemName = srcVC.itemNameTF.text
        let itemCount = srcVC.itemCountPV.selectedRow(inComponent: 0)
        let itemPrice = srcVC.itemLastPriceTF.text!
        let itemLL = srcVC.itemLastLocTF.text
        let itemLP = srcVC.itemLastPriceTF.text!
        let itemCate = srcVC.item?.category
        
        listOfItems[srcVC.indexOfItem!.row] = (Item(name: itemName!, count: Int(itemCount), price: Double(itemPrice)!, LPL: itemLL!, LPP: Double(itemLP)!, category: itemCate!, key: itemName!, owner: itemOwner!))
        
        updateData(item: listOfItems[srcVC.indexOfItem!.row], old: oldName)
    }
    
    func updateData(item: Item, old: String) {
        masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(old).removeValue()
        masterListRef.database.reference().child(CurrentUser.getUser().getGroup()).child(item.name).setValue(item.toAnyObject())
        masterListTV.reloadData()
    }
    
    @IBAction func unwindFromPersonalToMaster(segue:UIStoryboardSegue){
        let srcVC = segue.source as! PersonalTVC
        
        var newItems = [Item]()
        for items in srcVC.listOfItems {
            if (!listOfItems.contains(items)) {
                listOfItems.append(items)
                newItems.append(items)
            }
            else
            {
                print(listOfItems[listOfItems.index(of: items)!].count)
                listOfItems[listOfItems.index(of: items)!].count += 1
                print(listOfItems[listOfItems.index(of: items)!].count)
            }
        }
    
        for itm in newItems {
            let item = [
                "Item Name" : itm.name as String,
                "Count" : itm.count as Int,
                "Price" : itm.price as Double,
                "Last Purchased Location" : itm.lastPurchaseLocation as String,
                "Last Purchased Price" : itm.lastPurchasePrice as Double,
                "Category" : itm.category as String,
                "Owner" : itm.owner as String] as [String : Any]
            self.masterListRef.child(itm.name).setValue(item)
        }
        
        fetchData()
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

