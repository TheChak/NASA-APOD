//
//  APODViewControllerFactory.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

class APODViewControllerFactory {
    class func apodViewController(dataFacade: PhotoDataFacade,
                                           date: String,
                                           isFavorite: Bool,
                                           delegate: APODViewControllerDelegate) -> APODViewController {
        let viewController = UIStoryboard.photoOfToday.appInstantiateViewController(type: APODViewController.self)
        viewController.dataFacade = dataFacade
        viewController.date = date
        viewController.isFavorite = isFavorite
        viewController.delegate = delegate
        return viewController
    }
}
