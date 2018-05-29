//
//  CurrentUser.swift
//  Shoppr
//  semi - Singleton object, used to store the current user along with group that is active in the application

//  Created by Jacky Huang on 5/28/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import Foundation

class CurrentUser : NSObject{
    
    private var name: String
    private var group: String
    //private var inventory : [Item]
    private var cookBook : [SRRecipe]
    private static var sharedUser: CurrentUser = {
        let currUser = CurrentUser(name: "Defeault", group: "None", cookBook: [SRRecipe]())
        
        return currUser
    }()
    class func getUser() -> CurrentUser {
        return sharedUser
    }
    
    func getName () -> String {
        return self.name
    }
    func getGroup() -> String {
        return self.group
    }
    
    func setName(newName: String) {
        CurrentUser.getUser().name = newName
    }
    
    func setGroup(newGroup: String) {
        CurrentUser.getUser().group = newGroup
    }
    //func getInventory() -> [Item] {
    //    return self.inventory
   // }
    
    func getCookBook() -> [SRRecipe] {
        return self.cookBook
    }
    
    //func setInventory(newInventory: [Item]) {
    //    self.inventory = newInventory
    //}
    
    func setCookBook(newCookBook: [SRRecipe]) {
        self.cookBook = newCookBook
    }
    
    //func addItem(item: Item) {
    //    self.inventory.append(item)
    //}
    
    //func removeItem(index: Int) {
    //    self.inventory.remove(at: index)
    //}
    init(name: String, group: String, /*inventory: [Item],*/ cookBook: [SRRecipe]) {
        self.name = name
        self.group = group
        //self.inventory = inventory
        self.cookBook = cookBook
        
        super.init()
    }
}
