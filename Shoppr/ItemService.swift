//
//  ItemService.swift
//  Walmart API
//
//  Created by Local Account 436-05 on 5/29/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import Foundation

struct ItemService : Codable {
    let items : WalmartItem
    
    struct WalmartItems : Codable {
        let itemService : WalmartItem
    }
}
