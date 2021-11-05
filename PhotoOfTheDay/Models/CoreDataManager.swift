//
//  CoreDataManager.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 05/11/2021.
//

import CoreData
import Foundation

class CoreDataManager {
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PhotoOfTheDay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Could not load persistent store. Favorites will not be available. Error: \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    class func saveContext() -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let nserror = error as NSError
                print("Could not save to persistent store. Error: \(nserror.userInfo)")
                return false
            }
        }
        
        return false
    }
    
    class func saveFavorite(model: MediaDetailsModel) -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Favorites",
                                                   in: context),
           let favorite = NSManagedObject(entity: entity, insertInto: context) as? Favorites {
            
            favorite.title = model.title
            favorite.mediaDescription = model.explanation
            favorite.date = model.date
            favorite.hdurl = model.hdurl
            favorite.url = model.url
            favorite.mediaType = model.mediaType?.rawValue
            
            return CoreDataManager.saveContext()
        }
        
        return false
    }
    
    class func fetchFavorites() -> [Favorites]? {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            let nserror = error as NSError
            print("Could not fetch Favorites. Error: \(nserror.userInfo)")
            return nil
        }
    }
    
    class func deleteFavorite(date: String) -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        if let favorites = CoreDataManager.fetchSpecificFavorites(date: date) {
            for fav in favorites {
                context.delete(fav)
            }
            return CoreDataManager.saveContext()
        }
        return false
    }
    
    class func checkFavoriteExists(date: String) -> Bool {
        if let favorites = CoreDataManager.fetchSpecificFavorites(date: date),
           favorites.count > 0 {
            return true
        }
        return false
    }
    
    private class func fetchSpecificFavorites(date: String) -> [Favorites]? {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequestWithDate( date)
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            let nserror = error as NSError
            print("Could not fetch specific Favorites. Error: \(nserror.userInfo)")
            return nil
        }
    }
}
