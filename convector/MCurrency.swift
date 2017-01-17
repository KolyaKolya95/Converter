//
//  MCurrency.swift
//  convector
//
//  Created by Kolya on 08.12.16.
//  Copyright © 2016 Kolya. All rights reserved.
//

import Foundation

typealias JSON = [String : AnyObject]

class MCurrency {
    
    var source: String
    var quotes : [Quotes] = []
    
    init?(json: JSON){
        
        guard let source = json["source"] as? String,
            let jsonQuotes = json["quotes"] as? [String : AnyObject]
            else {
                return nil
        }
        
        self.source = source
        for (key, value) in jsonQuotes {
            if let value = value as? Double {
                let item = Quotes(name: key, val: value)
                quotes.append(item)
            }
        }
    }
}

struct Quotes {
    var name : String
    var val : Double
}



