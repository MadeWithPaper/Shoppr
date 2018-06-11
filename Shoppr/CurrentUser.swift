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
    
    func getCookBook() -> [SRRecipe] {
        return self.cookBook
    }
    
    func setCookBook(newCookBook: [SRRecipe]) {
        self.cookBook = newCookBook
    }
    
    init(name: String, group: String, cookBook: [SRRecipe]) {
        self.name = name
        self.group = group
        self.cookBook = cookBook
        
        super.init()
    }
}
