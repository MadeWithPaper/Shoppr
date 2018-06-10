//
//  Items.swift
//  Shoppr
//
//  Created by Jacky Huang on 5/26/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Item : NSObject{
    
    var name: String
    var count: Int
    var price: Double
   // var lastPurchaseLocation: String
    var lastPurchasePrice: Double
    var category: String
    var key: String
    var owner : String
    var ref : DatabaseReference?
    var store : String
    
    override var description: String {
        return String("Name: \(name)")
    }
    
    init(name: String, count: Int, price: Double, /*LPL: String,*/ LPP: Double, category: String, key: String, owner: String, store: String) {
        self.name = name
        self.count = count
        self.price = price
        ///self.lastPurchaseLocation = LPL
        self.lastPurchasePrice = LPP
        self.category = category
        self.key = key
        self.owner = owner
        self.store = store
        ref = nil
        
        super.init()
    }
    
    
    init(key: String,snapshot: DataSnapshot) {
        self.key = key
        
        let snaptemp = snapshot.value as! [String : AnyObject]
        let snapvalues = snaptemp[key] as! [String : AnyObject]
        
        name = snapvalues["Item Name"] as! String
        count = snapvalues["Count"] as! Int
        price = snapvalues["Price"] as! Double
        //lastPurchaseLocation = snapvalues["Last Purchased Location"] as! String
        lastPurchasePrice = snapvalues["Last Purchased Price"] as! Double
        category = snapvalues["Category"] as! String
        owner = snapvalues["Owner"] as! String
        store = snapvalues["Store"] as! String
        ref = snapshot.ref
        
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key

        let snapvalues = snapshot.value as! [String : AnyObject]
        
        name = snapvalues["Item Name"] as! String
        count = snapvalues["Count"] as! Int
        price = snapvalues["Price"] as! Double
        //lastPurchaseLocation = snapvalues["Last Purchased Location"] as! String
        lastPurchasePrice = snapvalues["Last Purchased Price"] as! Double
        category = snapvalues["Category"] as! String
        owner = snapvalues["Owner"] as! String
        store = snapvalues["Store"] as! String

        ref = snapshot.ref
        
        super.init()
        
    }
    
    func toAnyObject() -> Any {
        return [
            "Item Name" : name,
            "Count" : count,
            "Price" : price,
            //"Last Purchased Location" : lastPurchaseLocation,
            "Last Purchased Price" : lastPurchasePrice,
            "Category" : category,
            "Owner" : owner,
            "Store" : store
        ]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Item
        {
            return name == object.name &&
                    owner == object.owner &&
                    store == object.store
        }
        else
        {
            return false
        }
    }
}




