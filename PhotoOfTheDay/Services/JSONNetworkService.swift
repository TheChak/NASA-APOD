//
//  JSONNetworkService.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import Foundation

class JSONNetworkService: NetworkService {
    
    enum ServicePropertyKey: String {
        case apiKey = "api_key"
        case date
    }
    
    private let nasaDomain = "https://api.nasa.gov/planetary/apod?"
    
    init(properties: [(key: ServicePropertyKey, value: String)]) {
        var urlForRequest = nasaDomain
        properties.forEach {(property, value) in
            urlForRequest += property.rawValue + "=" + value + "&"
        }
        print("URL Request String: \(urlForRequest)")
        
        guard let url = URL(string: urlForRequest) else {
            fatalError("Invalid URL created")
        }
        
        let request = URLRequest(url: url)
        super.init(urlRequest: request)
    }
    
    init(url: URL) {
        print("URL Request String: \(url.absoluteString)")
        let request = URLRequest(url: url)
        super.init(urlRequest: request)
    }
}
