//
//  WalmartAPI.swift
//  Shoppr
//
//  Created by Local Account 436-05 on 6/9/18.
//  Copyright © 2018 Jacky Huang. All rights reserved.
//

import Foundation
import UIKit

func walmartAPICall(itemName: String) -> Double {
    //try to look up 50285046
    let apiKey = "csj9qk3nfx27xawrsswwd6tm"
    //var iem : WalmartItem?
    var it: WalmartItem.item?
    var empty = false

    let itm = itemName.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range:nil)
    
    var baseURL = "http://api.walmartlabs.com/v1/search?apiKey=\(apiKey)&query="
    baseURL += itm
    baseURL += "&sort=price&order=asc"
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    var request: URLRequest
    var url: URL?
    
    while(url == nil) {
        print("Base url: \(baseURL)")
        url = URL(string: baseURL)
    }
    
    request = URLRequest(url: url!)
    
    let task: URLSessionDataTask = session.dataTask(with: request)
    { (receivedData, response, error) -> Void in
        
        if let data = receivedData {
            do {
                let decoder = JSONDecoder()
                
                do {
                    let itemService = try decoder.decode(WalmartItem.self, from: data)
                    for i in itemService.items {
                        print(i)
                        it = i
                        break
                    }
                }
                // The item could not be found by the API call
                catch {
                    empty = true
                }
                
            } catch {
                
                print("Exception on Decode: \(error)")
            }
        }
    }
    
    task.resume()

    while(it?.salePrice == nil) {
        if(empty) {
            return 0.0
        }
        sleep(UInt32(0000.1))
    }
    
    return (it?.salePrice)!

}
