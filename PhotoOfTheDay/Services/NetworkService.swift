//
//  NetworkService.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 01/11/2021.
//

import Foundation

class NetworkService: ServiceProtocol {
    
    private var urlRequest: URLRequest
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    func execute(download: Bool = false, completion: @escaping CompletionHandler) {
        if download {
            NetworkFacade.submitDownloadTask(request: urlRequest, completion: completion)
        }
        else {
            NetworkFacade.submitDataTask(request: urlRequest, completion: completion)
        }
    }
}

class NetworkFacade {
    
    static let urlSession = URLSession.init(configuration: .default)
    
    class func submitDataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        urlSession.dataTask(with: request) { (data, urlResponse, error) in
            completion(data, error)
        }.resume()
    }
    
    class func submitDownloadTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        urlSession.downloadTask(with: request) { (url, urlResponse, error) in
            guard let url = url, (error == nil) else {
                completion(nil, error)
                return
            }
            
            let data = try? Data(contentsOf: url)
            completion(data, error)
            
        }.resume()
    }
}
