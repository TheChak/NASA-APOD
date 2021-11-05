//
//  NetworkServiceFactory.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 01/11/2021.
//

import Foundation

class NetworkServiceFactory: ServiceFactoryProtocol {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: Photos
    func mediaDetailsService(date: String) -> ServiceProtocol {
        JSONNetworkService(properties: [(.date, date), (.apiKey, apiKey)])
    }
    
    func mediaService(url: URL) -> ServiceProtocol {
        JSONNetworkService(url: url)
    }
}
