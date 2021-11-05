//
//  ServiceCache.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 04/11/2021.
//

import Foundation

class ServiceCache {
    
    private var cachedServices: [String: AnyObject] = [:]
    private var cacheKeys = [String]()
    private var numberOfCachedItems: Int
    
    init(numberOfCachedItems: Int) {
        self.numberOfCachedItems = numberOfCachedItems
    }
    
    func cache(payload: AnyObject, key: String) -> Bool {
        if cachedServices[key] != nil {
            cachedServices[key] = payload
            return true
        }
        else if cachedServices.count < numberOfCachedItems {
            cacheKeys.append(key)
            cachedServices[key] = payload
            return true
        }
        else if cachedServices.count >= numberOfCachedItems {
            if let purgedKey = cacheKeys.first {
                cachedServices.removeValue(forKey: purgedKey)
                cacheKeys.removeFirst()
            }
            cacheKeys.append(key)
            cachedServices[key] = payload
            return true
        }
        return false
    }
    
    func retrievePayload(for key: String) -> AnyObject? {
        return cachedServices[key]
    }
    
    func clearCache() {
        cachedServices.removeAll()
    }
}
