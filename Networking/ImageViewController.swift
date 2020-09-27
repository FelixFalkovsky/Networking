//
//  ImageViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 26.09.2020.
//

import UIKit

class ImageViewController: UIViewController {

    private let url = "https://i.imgur.com/yCDnSnB.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = false
        fetchImage()
    }

    func fetchImage() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NetworkManager.downloadImage(url: url) { (image) in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
}
