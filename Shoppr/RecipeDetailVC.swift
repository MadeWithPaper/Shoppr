//
//  RecipeDetailVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/27/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var indredientsList: UITextView!
    @IBOutlet weak var viewLinkButton: UIButton!
    @IBOutlet weak var addIngredientsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var selected: SRRecipe?
    var curUser: CurrentUser?
    
    let blackColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            print("in segue")
            print(destinationVC?.listOfItems.count)
            for i in (destinationVC?.listOfItems)! {
                print("checking list")
                print(i.name)
            }
            for i in ing {
                let temp = Item(name: i, count: 1, price: 0, LPL: "N/A", LPP: 0, category: "N/A", key: i, owner: CurrentUser.getUser().getName())
                if (destinationVC?.listOfItems.contains(temp))! {
                    print("contains")
                    destinationVC?.listOfItems[(destinationVC?.listOfItems.index(of: temp)!)!].count += 1
                    print(destinationVC?.listOfItems[(destinationVC?.listOfItems.index(of: temp)!)!].count)
                }
                else
                {
                    print("adding")
                    destinationVC?.listOfItems.append(temp)
                }
            }
        }
        else if(segue.identifier == "savedRecipesSegue") {
            let destinationVC = segue.destination as? RecipeResultVC
            destinationVC?.rec = self.selected
            destinationVC?.saved = true
        }
    }
    
    @IBAction func saveRecipeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "savedRecipesSegue", sender: self)
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
