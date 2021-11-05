//
//  ServiceProtocol.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 01/11/2021.
//

import Foundation

protocol ServiceProtocol {
    
    typealias CompletionHandler = (_ data: Data?, _ error: Error?) -> Void
    func execute(download: Bool, completion: @escaping CompletionHandler)
}
