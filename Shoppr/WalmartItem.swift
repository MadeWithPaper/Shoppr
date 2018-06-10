//
//  Item.swift
//  Walmart API
//
//  Created by Local Account 436-05 on 5/29/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import Foundation

struct WalmartItem : Codable {
    var items : [item]
    
    struct item : Codable {
        var name : String
        var salePrice : Double
        var thumbnailImage : String
    }
}
