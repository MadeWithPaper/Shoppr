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
    
    var selected: SRRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeNameLabel.text = selected?.title
        recipeImage.image = selected?.image
        let newString = selected?.ingredients.replacingOccurrences(of: ", ", with: "\n")
        indredientsList.text = newString
        
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
            
            for i in ing {
                destinationVC?.listOfItems.append(Item(name: i, count: 1, price: 0, LPL: "N/A", LPP: 0, category: "N/A", key: i, owner: "Gaston"))
            }
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
