//
//  ArchiveViewController.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import UIKit

protocol ArchiveViewControllerDelegate: class {
    func archiveViewController(_ archiveViewController: ArchiveViewController, didTapOnDate date: String)
}

class ArchiveViewController: UITableViewController {

    private let cellIdentifier = "ArchiveTableViewCell"
    weak var delegate: ArchiveViewControllerDelegate?
    var datesDataSource: [String] = []
    var searchDataSource: [String] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        tableView.reloadData()
        setupSearchController()
    }
    
    func setupDataSource() {
        let dateFormatter = DateHelper.formatter
        
        /// This (1995-06-16) is the date specified by the API as the first day an image was uploaded. https://github.com/nasa/apod-api#url-search-params--query-string-parameters
        if let historicalDate = dateFormatter.date(from: "1995-06-16") {
            var date = Date()
            
            while date >= historicalDate {
                datesDataSource.append(dateFormatter.string(from: date))
                if let nextDate = dateFormatter.calendar.date(byAdding: .day, value: -1, to: date) {
                    date = nextDate
                }
                else {
                    /// Avoiding a constant loop if for any reason next item to be added to date list is not found.
                    break
                }
            }
        }
    }
}

// MARK:- Search

extension ArchiveViewController {
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Date (YYYY-MM-DD)"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterDates(searchText: String) {
        searchDataSource = datesDataSource.filter({ (date) -> Bool in
            return date.contains(searchText)
        })
        
        tableView.reloadData()
    }
}

// MARK:- UITableViewDataSource

extension ArchiveViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchDataSource.count
        }
        return datesDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = fetchDate(at: indexPath)
        return cell
    }
}

// MARK:- UITableViewDelegate

extension ArchiveViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.archiveViewController(self, didTapOnDate: fetchDate(at: indexPath))
    }
    
    func fetchDate(at indexPath: IndexPath) -> String {
        let date: String
        if isSearching {
            date = searchDataSource[indexPath.row]
        }
        else {
            date = datesDataSource[indexPath.row]
        }
        return date
    }
}

// MARK:- UISearchResultsUpdating

extension ArchiveViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterDates(searchText: searchText)
        }
      }
}
