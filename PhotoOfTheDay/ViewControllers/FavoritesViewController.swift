//
//  FavoritesViewController.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 05/11/2021.
//

import UIKit

protocol FavoritesViewControllerDelegate: class {
    func favoritesViewController(_ favoritesViewController: FavoritesViewController, didTapOnEntryWithDate date: String)
}

class FavoritesViewController: UITableViewController {
    
    var dataFacade: PhotoDataFacade?
    weak var delegate: FavoritesViewControllerDelegate?
    
    var favoritesDataSource: [Favorites] = []
    private let cellIdentifier = "FavoriteTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesDataSource = dataFacade?.fetchFavorites() ?? []
        if favoritesDataSource.isEmpty {
            ErrorHelper.showError(message: .noFavorites, on: self)
        }
        tableView.reloadData()
    }

}

// MARK:- UITableViewDataSource

extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let favorite = favoritesDataSource[indexPath.row]
        cell.textLabel?.text = favorite.title
        cell.detailTextLabel?.text = favorite.date
        return cell
    }
}

// MARK:- UITableViewDelegate

extension FavoritesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let date = fetchDate(at: indexPath) {
            delegate?.favoritesViewController(self, didTapOnEntryWithDate: date)
        }
    }
    
    func fetchDate(at indexPath: IndexPath) -> String? {
        let favorite = favoritesDataSource[indexPath.row]
        return favorite.date
    }
}
