//
//  FavoritesCoordinator.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 05/11/2021.
//

import UIKit

class FavoritesCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dataFacade: PhotoDataFacade
    private let serviceCache: ServiceCache
    
    required init(navigationController: UINavigationController, serviceFactory: ServiceFactoryProtocol, serviceCache: ServiceCache) {
        self.navigationController = navigationController
        self.serviceCache = serviceCache
        self.dataFacade = PhotoDataFacade(serviceFactory: serviceFactory, serviceCache: serviceCache)
        let favoritesViewController = navigationController.viewControllers.first as? FavoritesViewController
        favoritesViewController?.dataFacade = dataFacade
        favoritesViewController?.delegate = self
    }
}

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func favoritesViewController(_ favoritesViewController: FavoritesViewController, didTapOnEntryWithDate date: String) {
        guard let navigationController = navigationController else{
            fatalError("Error on Navigation Controller on Favorites tab.")
        }
        let photoOfTheDayCoordinator = PhotoOfTodayCoordinator(navigationController: navigationController,
                                                               serviceFactory: dataFacade.serviceFactory,
                                                               serviceCache: serviceCache,
                                                               date: date)
        photoOfTheDayCoordinator.showMediaOfTheDay(isFavorite: true)
    }
}
