//
//  ErrorHelper.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 05/11/2021.
//

import UIKit

enum ErrorMessage: String {
    case load
    case setFavorite
    case removeFavorite
    case noFavorites
    case couldNotPlayVideo
    
    var description: String {
        switch self {
        case .load:
            return "There was an error loading the NASA APOD. Please pull down to refresh the page or visit our Archive"
        case .setFavorite:
            return "There was an error saving your favorite. Please try again."
        case .removeFavorite:
            return "There was an error remving your favorite. Please try again."
        case .noFavorites:
            return "Nothing to see here! \nAdd to your favorites by tapping the heart icon on the NASA Astronomy Photo of the Day."
        case .couldNotPlayVideo:
            return "There was an error loading the NASA APOD video. Please pull down to refresh the page or visit our Archive"
        }
    }
}

class ErrorHelper {
    class func showError(message: ErrorMessage, on viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "Error",
                                               message: message.description,
                                               preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok",
                                         style: .cancel,
                                         handler: nil)
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
