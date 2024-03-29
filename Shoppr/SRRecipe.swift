//
//  SRRecipe.swift
//  Swifty Recipes
//
//  Created by Lasse Hammer Priebe on 12/02/16.
//  Copyright © 2016 Hundredeni. All rights reserved.
//

import UIKit
import FirebaseDatabase

open class SRRecipe: NSObject, NSCoding {
    
    // MARK: Properties
    
    open let title: String!
    open let ingredients: String!
    open let url: URL!
    open let thumbnailUrl: URL?
    open var image : UIImage?
    var owner : String
    var ref : DatabaseReference?
    
    open var thumbnailImage: UIImage? {
        get {
            return SRPuppyClient.sharedClient().imageCache.imageWithIdentifier(thumbnailUrl?.path)
        }
        set {
            if let thumbnailPath = thumbnailUrl?.path {
                SRPuppyClient.sharedClient().imageCache.storeImage(newValue, withIdentifier: thumbnailPath)
            }
        }
    }
    
    fileprivate struct CodingKeys {
        static let Title = "title"
        static let Href = "href"
        static let Ingredients = "ingredients"
        static let Thumbnail = "thumbnail"
    }
    
    // MARK: Life Cycle
    
    public init(title: String, ingredients: String, url: URL, thumbnailUrl: URL?) {
        self.title = title
        self.ingredients = ingredients
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.image = nil
        self.owner = ""
        self.ref = nil
    }
    
    // MARK: NSCoding Protocol
    
    @objc open func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: CodingKeys.Title)
        aCoder.encode(url, forKey: CodingKeys.Href)
        aCoder.encode(ingredients, forKey: CodingKeys.Ingredients)
        aCoder.encode(thumbnailUrl, forKey: CodingKeys.Thumbnail)
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        image = nil
        title = aDecoder.decodeObject(forKey: CodingKeys.Title) as! String
        ingredients = aDecoder.decodeObject(forKey: CodingKeys.Ingredients) as! String
        url = aDecoder.decodeObject(forKey: CodingKeys.Href) as! URL
        thumbnailUrl = aDecoder.decodeObject(forKey: CodingKeys.Thumbnail) as! URL?
        owner = ""
    }
    
    init (title: String, ingredients: String, url: URL, thumbnailUrl: URL?, owner:String) {
        self.title = title
        self.ingredients = ingredients
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.owner = owner
    }
    
    init(snapshot: DataSnapshot) {
        
        let snapvalues = snapshot.value as! [String : AnyObject]
        
        title = snapvalues["Recipe Title"] as! String
        ingredients = snapvalues["Ingredients"] as! String
        let stringURL = NSURL(string: snapvalues["URL"] as! String)
        self.url = stringURL as URL?
        let stringThumbnailUrl = NSURL(string: snapvalues["Thumbnail URL"] as! String)
        self.thumbnailUrl = stringThumbnailUrl as URL?
        owner = snapvalues["Owner"] as! String
        
        ref = snapshot.ref
        
        super.init()
    }
    
    func toAnyObject() -> Any {
        return [
            "Recipe Title" : title,
            "Ingredients" : ingredients,
            "URL" : url,
            "Thumbnail URL" : thumbnailUrl!,
            "Owner" : owner
        ]
    }
    
    
    // MARK: - CustomStringConvertible Protocol
    override open var description: String {
        get {
            return "Recipe: \(title).\nIngredients: \(ingredients)"
        }
    }
}
