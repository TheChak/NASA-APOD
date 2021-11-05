//
//  DataFacade.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 02/11/2021.
//

import Foundation

class DataFacade: NSObject {
    
    typealias DetailsCompletionHandler = (_ model: MediaDetailsModel?) -> Void
    typealias MetaDataCompletionHandler = (_ data: Data?) -> Void
    
    let serviceFactory: ServiceFactoryProtocol
    let serviceCache: ServiceCache
    
    init(serviceFactory: ServiceFactoryProtocol, serviceCache: ServiceCache) {
        self.serviceFactory = serviceFactory
        self.serviceCache = serviceCache
    }
}
