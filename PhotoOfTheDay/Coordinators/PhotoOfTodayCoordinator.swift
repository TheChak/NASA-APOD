//
//  PhotoOfTodayCoordinator.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 01/11/2021.
//

import UIKit

class PhotoOfTodayCoordinator {
    
    fileprivate weak var navigationController: UINavigationController?
    weak var appCoordinator: AppCoordinator?
    let dataFacade: PhotoDataFacade
    let date: String
    
    required init(navigationController: UINavigationController, serviceFactory: ServiceFactoryProtocol, serviceCache: ServiceCache, date: String) {
        self.navigationController = navigationController
        self.dataFacade = PhotoDataFacade(serviceFactory: serviceFactory, serviceCache: serviceCache)
        self.date = date
        let apodViewController = navigationController.viewControllers.first as? APODViewController
        apodViewController?.dataFacade = dataFacade
        apodViewController?.date = date
        apodViewController?.delegate = self
    }
    
    func showMediaOfTheDay(isFavorite: Bool = false) {
        let viewController = PhotoOfTheDayViewControllerFactory.photoOfTheDayViewController(dataFacade: dataFacade,
                                                                                            date: date,
                                                                                            isFavorite: isFavorite,
                                                                                            delegate: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PhotoOfTodayCoordinator: APODViewControllerDelegate {
    func apodViewController(_ APODViewController: APODViewController, didFavoritePhoto ofDate: Date?) {
        
    }
}
