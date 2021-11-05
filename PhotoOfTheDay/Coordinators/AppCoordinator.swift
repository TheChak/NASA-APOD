//
//  AppCoordinator.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

class AppCoordinator {
    
    private weak var window: UIWindow?
    var photoOfTodayCoordinator: PhotoOfTodayCoordinator?
    var archiveCoordinator: ArchiveCoordinator?
    var favoritesCoordinator: FavoritesCoordinator?
    let serviceFactory: ServiceFactoryProtocol
    
    init(window: UIWindow) {
        self.window = window
        let tabBarController = UIStoryboard.main.appInstantiateInitialViewController(UITabBarController.self)
        #if USE_CANNED_DATA
        self.serviceFactory = CannedDataServiceFactory()
        #else
        let serviceCache = ServiceCache(numberOfCachedItems: 3)
        self.serviceFactory = NetworkServiceFactory(apiKey: "DEMO_KEY")
        #endif
        
        guard let tabBarViewControllers = tabBarController.viewControllers as? [UINavigationController] else {
            fatalError("Issue with Tab Bar setup.")
        }
        
        let photoOfTodayNavigationController = tabBarViewControllers[0]
        let today = DateHelper.formatter.string(from: Date())
        photoOfTodayCoordinator = PhotoOfTodayCoordinator(navigationController: photoOfTodayNavigationController,
                                                          serviceFactory: serviceFactory,
                                                          serviceCache: serviceCache,
                                                          date: today)
        photoOfTodayCoordinator?.appCoordinator = self
        window.rootViewController = tabBarController
        
        let archiveNavigationController = tabBarViewControllers[1]
        archiveCoordinator = ArchiveCoordinator(navigationController: archiveNavigationController,
                                                serviceFactory: serviceFactory,
                                                serviceCache: serviceCache)
        
        let favoritesNavigationController = tabBarViewControllers[2]
        favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController,
                                                    serviceFactory: serviceFactory,
                                                    serviceCache: serviceCache)
    }
}
