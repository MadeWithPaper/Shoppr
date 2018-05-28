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
    var userList = [Item]()
    var masterListRef: DatabaseReference!
    var userName : String = ""
    var currUser : String = ""
    let options = VisionCloudDetectorOptions()
    var vision = Vision.vision()

    @IBOutlet weak var tableView: UITableView!
    
    /*
    var googleAPIKey = "AIzaSyC8-JewdwPNlA-S8l90Ez0hDzfnWKdjT7U"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }*/
    
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    let whileColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = blueColor
        
        currUser = userName

        //Firebase database reference
        masterListRef = Database.database().reference().child("Master List")
        
        //testing function
        //testingInit()
        //self.listOfItems.removeAll()
        //self.userList.removeAll()
        /*masterListRef?.queryOrdered(byChild: "Master List").observe(.value, with:{ snapshot in
        for item in snapshot.children {
            //print(item)
            self.listOfItems.append(Item(snapshot: item as! DataSnapshot))
            let temp = Item(snapshot: item as! DataSnapshot)
            if (temp.owner == self.currUser) {
                self.userList.append(Item(snapshot: item as! DataSnapshot))
            }
        }
        })*/
            fetchDate()
        
        //image scanning

        // options.maxResults has no effect with this API
        // Defining a SwipeUp Gesture
        /*let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        */
        
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        navigationItem.leftBarButtonItem = camera
        
        
        // Defining a SwipeLeft Gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = blueColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        masterListTV.reloadData()
    }
    
    func fetchDate() {
        self.masterListRef.observe(.childAdded, with: { snapshot in
            for item in snapshot.children {
                //print(item)
                self.listOfItems.append(Item(snapshot: item as! DataSnapshot))
                let temp = Item(snapshot: item as! DataSnapshot)
                if (temp.owner == self.currUser) {
                    self.userList.append(Item(snapshot: item as! DataSnapshot))
                }
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PersonalListSegue") {
            let destVC = segue.destination as! PersonalTVC
            print(userList.count)
            destVC.listOfItems = userList
            destVC.masterListRef = masterListRef
            print("going to \(currUser)'s detail list view")
        }
        else if (segue.identifier == "masterItemDetail") {
            if let indexPath = masterListTV.indexPathForSelectedRow {
                let object = listOfItems[(indexPath as NSIndexPath).row]
                let destVC = segue.destination as! itemDetailView
                destVC.item = object
                destVC.master = true
                print("going to item detail view from master")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        
        switch gestureRecognizer.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("Swipped Left")
            performSegue(withIdentifier: "PersonalListSegue", sender: self)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let textDetector = vision.cloudTextDetector(options: options)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("picked image")
            let image = VisionImage(image: pickedImage)
            textDetector.detect(in: image) { (cloudText, error) in
                guard error == nil, let cloudText = cloudText else {
                    print("image fetch error")
                    return
                }
                // Recognized and extracted text
                let recognizedText = cloudText.text
                print(recognizedText ?? "nothing is here")
                for t in recognizedText! {
                    print(t)
                }
            }
        }
        dismiss(animated: true, completion: nil)
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
        cell.itemCountLabel.text = String(object.count)
        cell.itemPriceLabel.text = String(object.price)
        cell.lastLocAndPriceLabel.text = "Last purchased at \(object.lastPurchaseLocation) for $\(object.lastPurchasePrice)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "masterItemDetail", sender: self)
    }
    
    @IBAction func unwindFromDetail(segue:UIStoryboardSegue) {
        print("returning back to master view form personal view")
    }
    
    func testingInit() {
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
    }
}

