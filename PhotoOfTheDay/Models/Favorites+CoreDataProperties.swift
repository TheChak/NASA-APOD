//
//  Favorites+CoreDataProperties.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 05/11/2021.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }
    
    @nonobjc public class func fetchRequestWithDate(_ date: String) -> NSFetchRequest<Favorites> {
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate.init(format: "date == %@", date)
        return fetchRequest
    }

    @NSManaged public var date: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var mediaDescription: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension Favorites : Identifiable {

}
