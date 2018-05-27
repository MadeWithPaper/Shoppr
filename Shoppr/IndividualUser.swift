//
//  IndividualUser.swift
//  
//
//  Created by Jacky Huang on 5/26/18.
//

import Foundation
import FirebaseDatabase

class IndividualUser : NSObject{
    
    var name: String
    var listOfItems: [Item];
    var ref : DatabaseReference?
    var key : String
    
    init(name: String, listOfItems: [Item], key: String) {
        self.name = name
        self.listOfItems = listOfItems
        self.key = key
        ref = nil
        
        super.init()
    }

    
    init(key: String,snapshot: DataSnapshot) {
        self.key = key
        
        let snaptemp = snapshot.value as! [String : AnyObject]
        let snapvalues = snaptemp[key] as! [String : AnyObject]
        
        name = snapvalues["User Name"] as! String
        listOfItems = snapvalues["Item List"] as! [Item]
        
        ref = snapshot.ref
        
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        
        let snapvalues = snapshot.value as! [String : AnyObject]
        
        name = snapvalues["User Name"] as! String
        listOfItems = snapvalues["Item List"] as! [Item]
        
        ref = snapshot.ref
        
        super.init()
        
    }
    
    func toAnyObject() -> Any {
        return [
            "Item Name" : name,
            "Item List" : listOfItems
        ]
    }
}




