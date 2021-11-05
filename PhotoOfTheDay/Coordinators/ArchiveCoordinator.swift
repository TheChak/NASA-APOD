//
//  ArchiveCoordinator.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

class ArchiveCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let serviceFactory: ServiceFactoryProtocol
    private let serviceCache: ServiceCache
    
    required init(navigationController: UINavigationController, serviceFactory: ServiceFactoryProtocol, serviceCache: ServiceCache) {
        self.navigationController = navigationController
        self.serviceFactory = serviceFactory
        self.serviceCache = serviceCache
        let archiveViewController = navigationController.viewControllers.first as? ArchiveViewController
        archiveViewController?.delegate = self
    }
}

extension ArchiveCoordinator: ArchiveViewControllerDelegate {
    func archiveViewController(_ archiveViewController: ArchiveViewController, didTapOnDate date: String) {
        guard let navigationController = navigationController else{
            fatalError("Error on Navigation Controller on Archive tab.")
        }
        let apodCoordinator = APODCoordinator(navigationController: navigationController,
                                                               serviceFactory: serviceFactory,
                                                               serviceCache: serviceCache,
                                                               date: date)
        apodCoordinator.showMediaOfTheDay()
    }
}
