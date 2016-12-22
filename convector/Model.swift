//
//  Model.swift
//  convector
//
//  Created by Kolya on 08.12.16.
//  Copyright © 2016 Kolya. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

struct Currency {
    var source: String
    var quotes : (name: String, value: Double)
}

extension Currency {
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
