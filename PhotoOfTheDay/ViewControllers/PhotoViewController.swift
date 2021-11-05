//
//  PhotoViewController.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 01/11/2021.
//

import UIKit

protocol PhotoViewControllerDelegate: class {
    func photoViewController(_ photoViewController: PhotoViewController, didFavoritePhoto ofDate: Date?)
}

class PhotoViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    @IBOutlet var descriptionTableView: UITableView!
    
    var dataFacade: PhotoDataFacade?
    weak var delegate: PhotoViewControllerDelegate?
    var date: String?
    var isFavorite = false
    
    weak var mediaViewController: MediaViewController?
    var mediaDescription: String?
    var mediaTitle: String?
    var mediaDetailsModel: MediaDetailsModel?
    
    private let titleCellIdentifier = "TitleCell"
    private let descriptionCellIdentifier = "DescriptionCell"
    private let refreshControl = UIRefreshControl()
    let defaultDate = DateHelper.formatter.string(from: Date())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "NASA APOD " + (date ?? "")
        
        setupRefreshControl()
        setupFavoriteButton()
        descriptionTableView.tableFooterView = UIView()
        reloadScreen()
    }
    
    // MARK: - UI Setup
    
    func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Reload the screen")
        refreshControl.addTarget(self, action: #selector(reloadScreen), for: .valueChanged)
        descriptionTableView.addSubview(refreshControl)
        
    }
    
    func setupFavoriteButton() {
        if let favCheck = dataFacade?.checkFavoriteExists(date: date ?? defaultDate) {
            isFavorite = favCheck
        }
        
        if isFavorite {
            favoriteButton.image = UIImage.init(systemName: "heart.fill")
        }
        else {
            favoriteButton.image = UIImage.init(systemName: "heart")
        }
        
    }
    
    // MARK: - Fetching and Displaying
    
    @objc func reloadScreen() {
        mediaViewController?.setupLoader()
        fetchDetails()
    }
    
    func fetchDetails() {
        dataFacade?.getDetails(date: date ?? defaultDate, completion: {[weak self] (mediaDetailsModel) in
            guard let model = mediaDetailsModel,
                  let urlString = model.url,
                  let url = URL(string: urlString),
                  model.mediaType != .unknown else {
                
                self?.mediaViewController?.loadMedia(data: Data(), type: .unknown)
                self?.refreshControl.endRefreshing()
                if let weakSelf = self {
                    ErrorHelper.showError(message: .load, on: weakSelf)
                }
                return
            }
            
            self?.loadMedia(model: model, url: url)
        })
    }
    
    func loadMedia(model: MediaDetailsModel, url: URL) {
        self.mediaDetailsModel = model
        self.mediaTitle = model.title
        self.mediaDescription = model.explanation
        
        DispatchQueue.main.async {
            self.descriptionTableView.reloadData()
        }
        
        if let mediaType = mediaDetailsModel?.mediaType,
           mediaType == .video,
           let mediaController = mediaViewController {
            DispatchQueue.main.async {
                mediaController.loadMedia(data: url, type: mediaType)
                self.refreshControl.endRefreshing()
            }
            return
        }
        else if let mediaType = mediaDetailsModel?.mediaType, mediaType == .image {
            dataFacade?.loadPhoto(url: url, completion: {[weak self] (data) in
                
                DispatchQueue.main.async {
                    if let mediaController = self?.mediaViewController, (data != nil) {
                        mediaController.loadMedia(data: data, type: self?.mediaDetailsModel?.mediaType ?? .unknown)
                    }
                    else if let weakSelf = self {
                        ErrorHelper.showError(message: .load, on: weakSelf)
                    }
                    self?.refreshControl.endRefreshing()
                }
            })
        }
        else {
            DispatchQueue.main.async {
                self.mediaViewController?.loadMedia(data: Data(), type: .unknown)
            }
        }
    }
    

    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "MediaSegue" {
             mediaViewController = segue.destination as? MediaViewController
         }
     }
    
    // MARK: - Favorite
    
    @IBAction func didTapFavorite(_ sender: UIBarButtonItem) {
        if let model = mediaDetailsModel, let favDate = date {
            if isFavorite {
                if let didDelete = dataFacade?.deleteFavorite(from: favDate),
                   didDelete == true {
                    isFavorite = false
                    favoriteButton.image = UIImage.init(systemName: "heart")
                }
                else {
                    ErrorHelper.showError(message: .removeFavorite, on: self)
                }
            }
            else{
                if let didSave = dataFacade?.saveFavorite(model: model),
                   didSave == true {
                    isFavorite = true
                    favoriteButton.image = UIImage.init(systemName: "heart.fill")
                }
                else {
                    ErrorHelper.showError(message: .setFavorite, on: self)
                }
            }
        }
    }
}

extension PhotoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: titleCellIdentifier, for: indexPath)
            cell.textLabel?.text = mediaTitle
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath)
            cell.textLabel?.text = mediaDescription
        }
        return cell
    }
}
