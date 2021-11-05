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
        let photoViewController = navigationController.viewControllers.first as? PhotoViewController
        photoViewController?.dataFacade = dataFacade
        photoViewController?.date = date
        photoViewController?.delegate = self
    }
    
    func showMediaOfTheDay(isFavorite: Bool = false) {
        let viewController = PhotoOfTheDayViewControllerFactory.photoOfTheDayViewController(dataFacade: dataFacade,
                                                                                            date: date,
                                                                                            isFavorite: isFavorite,
                                                                                            delegate: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PhotoOfTodayCoordinator: PhotoViewControllerDelegate {
    func photoViewController(_ photoViewController: PhotoViewController, didFavoritePhoto ofDate: Date?) {
        
    }
}
