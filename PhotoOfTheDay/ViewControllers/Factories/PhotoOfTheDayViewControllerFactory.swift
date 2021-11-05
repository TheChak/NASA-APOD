//
//  PhotoOfTheDayViewControllerFactory.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

class PhotoOfTheDayViewControllerFactory {
    class func photoOfTheDayViewController(dataFacade: PhotoDataFacade,
                                           date: String,
                                           isFavorite: Bool,
                                           delegate: PhotoViewControllerDelegate) -> PhotoViewController {
        let viewController = UIStoryboard.photoOfToday.appInstantiateViewController(type: PhotoViewController.self)
        viewController.dataFacade = dataFacade
        viewController.date = date
        viewController.isFavorite = isFavorite
        viewController.delegate = delegate
        return viewController
    }
}
