//
//  UIStoryboard+PhotoOfTheDay.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

extension UIStoryboard {
    
    private enum AppStoryboardName: String {
        case main = "Main"
        case photoOfToday = "PhotoOfToday"
        case archive = "Archive"
        case favorites = "Favorites"
    }
    
    class var main: UIStoryboard {
        return UIStoryboard(name: AppStoryboardName.main.rawValue, bundle: nil)
    }
    
    class var photoOfToday: UIStoryboard {
        return UIStoryboard(name: AppStoryboardName.photoOfToday.rawValue, bundle: nil)
    }
    
    class var archive: UIStoryboard {
        return UIStoryboard(name: AppStoryboardName.archive.rawValue, bundle: nil)
    }
    
    class var favorites: UIStoryboard {
        return UIStoryboard(name: AppStoryboardName.favorites.rawValue, bundle: nil)
    }
    
    func appInstantiateInitialViewController<T>(_: T.Type) -> T {
        guard let viewController = self.instantiateInitialViewController() as? T else {
            fatalError("Initial view controller type is wrong.")
        }
        return viewController
    }
    
    func appInstantiateViewController<T>(withIdentifier identifier: String = String(describing: T.self), type: T.Type) -> T {
        let storyboardViewController = self.instantiateViewController(withIdentifier: identifier)
        guard let viewController = storyboardViewController as? T else {
            fatalError("View controller type inside storyboard is wrong.")
        }
        return viewController
    }
}
