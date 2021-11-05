//
//  MediaViewController.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

import AVFoundation
import UIKit
import WebKit

class MediaViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    //@IBOutlet var containerView: UIView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
    }
    
    func setupLoader(animate: Bool = true) {
        if animate {
            activityIndicator.startAnimating()
            view.bringSubviewToFront(activityIndicator)
        }
        else {
            activityIndicator.stopAnimating()
            view.sendSubviewToBack(activityIndicator)
        }
        activityIndicator.isHidden = !animate
    }
    
    func loadMedia<T>(data: T?, type: MediaType) {
        if type == .image {
            if let data = data as? Data {
                imageView.image = UIImage(data: data)
            }
            else{
                imageView.image = UIImage.init(systemName: "photo")
                ErrorHelper.showError(message: .load, on: self)
            }
            setupLoader(animate: false)
        }
        else if type == .video {
            if let url = data as? URL {
                print("NASA APOD video URL is: \(url.absoluteString)")
                setupWebview(url: url)
            }
            else{
                imageView.image = UIImage.init(systemName: "photo")
                ErrorHelper.showError(message: .couldNotPlayVideo, on: self)
            }
            setupLoader(animate: false)
        }
        else {
            setupLoader(animate: false)
            imageView.image = UIImage.init(systemName: "photo")
            ErrorHelper.showError(message: .load, on: self)
        }
    }
    
    private func setupWebview(url: URL) {
        let urlRequest = URLRequest.init(url: url)
        webView.isHidden = false
        view.bringSubviewToFront(webView)
        webView.load(urlRequest)
    }
    
    private func clearWebview() {
        webView.stopLoading()
        if let blankRequest = URL(string: "about:blank") {
            let urlRequest = URLRequest.init(url: blankRequest)
            webView.load(urlRequest)
        }
        webView.isHidden = true
        view.sendSubviewToBack(webView)
    }
}
