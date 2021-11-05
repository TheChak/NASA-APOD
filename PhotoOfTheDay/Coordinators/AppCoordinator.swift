//
//  AppCoordinator.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

enum TabIndex: Int {
    case media = 0
    case archive
    case favorites
}

class AppCoordinator {
    
    private weak var window: UIWindow?
    var apodCoordinator: APODCoordinator?
    var archiveCoordinator: ArchiveCoordinator?
    var favoritesCoordinator: FavoritesCoordinator?
    let serviceFactory: ServiceFactoryProtocol
    
    init(window: UIWindow) {
        self.window = window
        let tabBarController = UIStoryboard.main.appInstantiateInitialViewController(UITabBarController.self)
        #if USE_CANNED_DATA
        /// This file does not exist right now. This is to demonstrate how easily canned responses can be added to unit/automation testing or a demo mode of the app.
        self.serviceFactory = CannedDataServiceFactory()
        #else
        let serviceCache = ServiceCache(numberOfCachedItems: 5)
        self.serviceFactory = NetworkServiceFactory(apiKey: "DEMO_KEY")
        #endif
        
        guard let tabBarViewControllers = tabBarController.viewControllers as? [UINavigationController] else {
            fatalError("Issue with Tab Bar setup.")
        }
        
        let photoOfTodayNavigationController = tabBarViewControllers[TabIndex.media.rawValue]
        let today = DateHelper.formatter.string(from: Date())
        apodCoordinator = APODCoordinator(navigationController: photoOfTodayNavigationController,
                                                          serviceFactory: serviceFactory,
                                                          serviceCache: serviceCache,
                                                          date: today)
        apodCoordinator?.appCoordinator = self
        window.rootViewController = tabBarController
        
        let archiveNavigationController = tabBarViewControllers[TabIndex.archive.rawValue]
        archiveCoordinator = ArchiveCoordinator(navigationController: archiveNavigationController,
                                                serviceFactory: serviceFactory,
                                                serviceCache: serviceCache)
        
        let favoritesNavigationController = tabBarViewControllers[TabIndex.favorites.rawValue]
        favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController,
                                                    serviceFactory: serviceFactory,
                                                    serviceCache: serviceCache)
    }
}
