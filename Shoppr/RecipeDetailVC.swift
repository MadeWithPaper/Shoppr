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
        
        print("In viewDidLoad")
        print(selected)
        
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
        //TODO: Add all ingredients to personal list!
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
