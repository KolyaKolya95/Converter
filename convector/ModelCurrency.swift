//
//  ModelCurrency.swift
//  TestObjectMapper
//
//  Created by Kolya on 15.11.16.
//  Copyright © 2016 Kolya. All rights reserved.
//

import UIKit

typealias JSON = [String : Any]

class ModelCurrency {
    
    var source: String
    
    var quotes : (name: String, value: Double)
    
    init?(json: JSON){
        
        guard let source = json["source"] as? String,
            let quotes = json["quotes"] as? [String : AnyObject],
            let name = quotes["name"],
            let value = quotes["value"]
            else {
                return nil
        }
        
        self.source = source
        self.quotes = (name as! String, value as! Double)
    }
}






