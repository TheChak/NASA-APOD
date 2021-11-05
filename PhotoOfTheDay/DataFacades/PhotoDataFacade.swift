//
//  PhotoDataFacade.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 02/11/2021.
//

import Foundation

class PhotoDataFacade: DataFacade {
    
    func getDetails(date: String, completion: @escaping DetailsCompletionHandler) {
        
        if let model = serviceCache.retrievePayload(for: date) as? MediaDetailsModel {
            completion(model)
            return
        }
        
        let service = serviceFactory.mediaDetailsService(date: date)
        service.execute(download: false) {[weak self] (data, error) in
            guard let jsonData = data, error == nil,
                  let model = self?.parseMediaDetails(jsonData: jsonData) else {
                completion(nil)
                return
            }
            
            if let key = model.date {
                _ = self?.serviceCache.cache(payload: model.self as AnyObject, key: key)
            }
            
            completion(model)
        }
    }
    
    func loadPhoto(url: URL, type: MediaType = .image, completion: @escaping MetaDataCompletionHandler) {
        let service = serviceFactory.mediaService(url: url)
        service.execute(download: true) { (data, error) in
            completion(data)
        }
    }
}

// MARK:- Parsing

extension PhotoDataFacade {
    private func parseMediaDetails(jsonData: Data) -> MediaDetailsModel? {
        let decoder = JSONDecoder()
        guard let data = try? decoder.decode(MediaDetailsModel.self, from: jsonData) else {
            print("Decoding Failed for Media details.")
            return nil
        }
        
        return data.self
    }
}

// MARK:- Core Data

extension PhotoDataFacade {
    func fetchFavorites() -> [Favorites]? {
        return CoreDataManager.fetchFavorites()
    }
    
    func saveFavorite(model: MediaDetailsModel) -> Bool {
        return CoreDataManager.saveFavorite(model: model)
    }
    
    func deleteFavorite(from date: String) -> Bool {
        return CoreDataManager.deleteFavorite(date: date)
    }
    
    func checkFavoriteExists(date: String) -> Bool {
        return CoreDataManager.checkFavoriteExists(date: date)
    }
}
