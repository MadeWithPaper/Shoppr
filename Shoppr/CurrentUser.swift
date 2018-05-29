//
//  CurrentUser.swift
//  Shoppr
//  Singleton object, used to store the current user along with group that is active in the application

//  Created by Jacky Huang on 5/28/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import Foundation

class CurrentUser : NSObject{
    
    var name: String
    var group: String
    var inventory : [Item]
    var cookBook : [SRRecipe]
    
    func getUser() -> String {
        return self.name
    }
    
    func getGroup() -> String {
        return self.group
    }
    
    func getInventory() -> [Item] {
        return self.inventory
    }
    
    func getCookBook() -> [SRRecipe] {
        return self.cookBook
    }
    init(name: String, group: String, inventory: [Item], cookBook: [SRRecipe]) {
        self.name = name
        self.group = group
        self.inventory = inventory
        self.cookBook = cookBook
        
        super.init()
    }
}
