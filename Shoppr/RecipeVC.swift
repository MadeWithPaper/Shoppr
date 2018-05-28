//
//  RecipeVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit

class RecipeVC: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var recipes: [SRRecipe]?
    var query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.isHidden = false
        activityIndicator.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        
        query = self.searchField.text!
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async {

            
            SRPuppyClient.sharedClient().fetchRecipesWithQuery(self.query, completionHandler: {
                result, _ in
                self.recipes = result
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.performSegue(withIdentifier: "recipeResultSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "recipeResultSegue"){
            let destinationVC = segue.destination as? RecipeResultVC
            
            destinationVC?.recipes = self.recipes
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
