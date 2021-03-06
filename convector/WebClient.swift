//
//  WebClient.swift
//  convector
//
//  Created by Kolya on 08.12.16.
//  Copyright © 2016 Kolya. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}

final class WebClient {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    init() {
        baseUrl = "http://www.apilayer.net/api/live"
    }
    
    
    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        if !Reachability.isConnectedToNetwork() {
            completion(nil, ServiceError.noInternetConnection)
            return nil
        }
        
        
        let parameters: JSON = ["access_key": "ad847a0a855c0647590df2b818923025" as AnyObject]
        
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: parameters)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var object: Any?
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil)
            } else {
                let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                completion(nil, error)
            }
        }
        
        task.resume()
        
        return task
    }
}
