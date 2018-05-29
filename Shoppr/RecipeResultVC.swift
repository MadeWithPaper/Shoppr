//
//  RecipeResultVC.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 5/27/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var recipes = [SRRecipe]()
    var rec: SRRecipe?
    @IBOutlet weak var tableView: UITableView!
    var sel = 0
    var recipesRef: DatabaseReference!
    var curUsr : CurrentUser?
    var saved : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        recipesRef = Database.database().reference().child("Recipe")
        if(rec != nil) {
            recipes.append(rec!)
            updateData()
        }
        if (saved) {
            fetchData()
        }
        //print(rec)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func updateData() {
        for r in self.recipes
        {
            let recipe = [
                "Recipe Title" : r.title as String,
                "Ingredients" : r.ingredients as String,
                "URL" : r.url.absoluteString as String,
                "Thumbnail URL" : r.thumbnailUrl?.absoluteString as! String,
                "Owner" : r.owner as String ] as [String : Any]
            self.recipesRef.child(r.title).setValue(recipe)
        }
    }
    
    func fetchData() {
        recipes.removeAll()
        recipesRef?.queryOrdered(byChild: "Recipe").observe(.value, with:
            { snapshot in
                var newRecipes = [SRRecipe]()
                
                for item in snapshot.children{
                    let temp = SRRecipe(snapshot: item as! DataSnapshot)
                    if temp.owner == CurrentUser.getUser().getName() {
                        newRecipes.append(temp)
                    }
                }
                self.recipes = newRecipes
                self.tableView.reloadData()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailRecipeSegue") {
            let destinationVC = segue.destination as? RecipeDetailVC
            let indexPath = tableView.indexPathForSelectedRow
            destinationVC?.selected = recipes[((indexPath as NSIndexPath?)?.row)!]
            destinationVC?.curUser = self.curUsr
        }
    }
    
    @IBAction func unwindToRecipes(segue:UIStoryboardSegue) {
        print("unwindToRecipes")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        
        let object = recipes[(indexPath as NSIndexPath).row]
        
        cell.recipeName.text = object.title
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let url = object.thumbnailUrl
            let responseData = try? Data(contentsOf: url!)
            let downloadedImage = UIImage(data: responseData!)
            
            DispatchQueue.main.async {
                cell.imageView?.image = downloadedImage
                object.image = downloadedImage
                cell.imageView?.isHidden = false
            }
        }
        return cell
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
