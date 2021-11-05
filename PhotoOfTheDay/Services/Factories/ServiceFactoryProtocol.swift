//
//  PhotoServiceFactoryProtocol.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 01/11/2021.
//

import Foundation

protocol ServiceFactoryProtocol {
    
    // MARK: Photos
    
    func mediaDetailsService(date: String) -> ServiceProtocol
    func mediaService(url: URL) -> ServiceProtocol
}
