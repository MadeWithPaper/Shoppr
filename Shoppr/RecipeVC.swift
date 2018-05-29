//
//  RecipeVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeVC: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var backButton: UIButton!
    var recipes: [SRRecipe]?
    var query: String = ""
    let blueColor = UIColor(red: 30/255.0, green: 204/255.0, blue: 241/255.0, alpha: 1.0)
    let blackColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    var recipesRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesRef = Database.database().reference().child("Recipe")
        
        self.view.backgroundColor = blueColor
        image.isHidden = false
        activityIndicator.isHidden = true
        
        
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = blackColor.cgColor
        searchButton.layer.cornerRadius = 5.0
        searchButton.clipsToBounds = true
        
        
        backButton.layer.borderWidth = 2.0
        backButton.layer.borderColor = blackColor.cgColor
        backButton.layer.cornerRadius = 5.0
        backButton.clipsToBounds = true
        
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
    
    
    @IBAction func unwindToRecipeVC(segue: UIStoryboardSegue){
        activityIndicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "recipeResultSegue"){
            let destinationVC = segue.destination as? RecipeResultVC
            
            destinationVC?.recipes = self.recipes!
            destinationVC?.saved = false
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
