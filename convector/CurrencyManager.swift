//
//  CurrencyManager.swift
//  convector
//
//  Created by Kolya on 06.12.16.
//  Copyright © 2016 Kolya. All rights reserved.
//  let URL = "http://www.apilayer.net/api/live?access_key=ad847a0a855c0647590df2b818923025"


import UIKit

class CurrencyManager: NSObject {
    
    static let sharedInstance = CurrencyManager()
    
    
    func getСurrency(complection:@escaping ([ModelCurrency])->()){
        get(request: clientURLRequest(path: "http://www.apilayer.net/api/live?access_key=ad847a0a855c0647590df2b818923025")) { (success, object) in
            var curennces: [ModelCurrency] = []
            
            if let object = object as? Dictionary<String, AnyObject> {
                if let results = object["results"] as? [Dictionary<String, AnyObject>] {
                    for result in results {
                        if let curenncy = ModelCurrency(json) {
                            curennces.append(curenncy)
                        }
                    }
                }
            }
            complection(curennces)
        }
    }
    
    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "http://www.apilayer.net/"+path)! as URL)
        
        return request
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }
}
