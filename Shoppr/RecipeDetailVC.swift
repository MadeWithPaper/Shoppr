//
//  RecipeDetailVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/27/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeDetailVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var indredientsList: UITextView!
    @IBOutlet weak var viewLinkButton: UIButton!
    @IBOutlet weak var addIngredientsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    var selected: SRRecipe?
    var curUser: CurrentUser?
    var itemList = [Item]()
    let blackColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)

    var masterListRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.backgroundColor = blueColor
        indredientsList.backgroundColor = blueColor
        
        recipeNameLabel.text = selected?.title
        recipeImage.image = selected?.image
        let newString = selected?.ingredients.replacingOccurrences(of: ", ", with: "\n")
        indredientsList.text = newString
        
        //view.backgroundColor = blueColor
        
        addIngredientsButton.layer.borderWidth = 1.0
        addIngredientsButton.layer.borderColor = blackColor.cgColor
        addIngredientsButton.layer.cornerRadius = 5.0
        addIngredientsButton.clipsToBounds = true
        
        viewLinkButton.layer.borderWidth = 1.0
        viewLinkButton.layer.borderColor = blackColor.cgColor
        viewLinkButton.layer.cornerRadius = 5.0
        viewLinkButton.clipsToBounds = true
        
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = blackColor.cgColor
        saveButton.layer.cornerRadius = 5.0
        saveButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        masterListRef = Database.database().reference().child(CurrentUser.getUser().getGroup())
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData()
    {
        itemList.removeAll()
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
                        self.itemList.append(itm)
                    }
                }
        })
    }
    @IBAction func viewLinkPressed(_ sender: UIButton) {
        UIApplication.shared.open((selected?.url)!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func AddIngredientsButtonPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add to Shopping List?", message: "Selecting yes will add all the ingredients to your personal shopping list", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            //TODO perform seguge and add stuff
            self.performSegue(withIdentifier: "addIngredientsSegue", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addIngredientsSegue"){
            let ing = indredientsList.text.components(separatedBy: "\n")
            let destinationVC = segue.destination as? PersonalTVC

            for i in ing {
                let price = walmartAPICall(itemName: i)
                //sleep(3)
                let temp = Item(name: i, count: 1, price: price, /*LPL: "N/A", LPP: 0,*/ category: "N/A", key: i, owner: CurrentUser.getUser().getName(), store: "N/A")
                if (itemList.contains(temp)) {
                    print("contains")
                    itemList[(itemList.index(of: temp)!)].count += temp.count
                    //print(destinationVC?.listOfItems[(destinationVC?.listOfItems.index(of: temp)!)!].count)
                }
                else
                {
                    print("adding")
                    itemList.append(temp)
                }
            }
            destinationVC?.listOfItems = itemList
        }
        else if(segue.identifier == "savedRecipesSegue") {
            let destinationVC = segue.destination as? RecipeResultVC
            self.selected?.owner = (CurrentUser.getUser().getName())
            destinationVC?.rec = self.selected
            destinationVC?.saved = true
        }
    }
    
    @IBAction func saveRecipeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "savedRecipesSegue", sender: self)
    }
    
    func updateData()
    {
        for s in self.itemList
        {
            let item = [
                "Item Name" : s.name as String,
                "Count" : s.count as Int,
                "Price" : s.price as Double,
                "Last Purchased Location" : s.store as String,
                //"Last Purchased Price" : s.lastPurchasePrice as Double,
                "Category" : s.category as String,
                "Owner" : s.owner as String] as [String : Any]
            self.masterListRef.child(s.name).setValue(item)
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
