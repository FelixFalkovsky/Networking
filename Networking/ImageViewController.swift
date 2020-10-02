//
//  ImageViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 26.09.2020.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {

    private let url = "https://i.imgur.com/yCDnSnB.jpg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    
    @IBOutlet var completedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        activityIndicator.isHidden = true
//        activityIndicator.hidesWhenStopped = false
//    }
    
    func fetchDataWithAlamofire() {
        AF.request(url).response { (responseData) in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data!) else { return }  
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            case.failure(let error):
                print(error)
            }
        }
    }
    func fetchImage() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NetworkManager.downloadImage(url: url) { (image) in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    func downloadImageWithProgress() {
        print("Download image with progress PRESS!")
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        AlamofireNetworkRequest.complited = { completed in
            self.completedLabel.isHidden = false
            self.completedLabel.text = completed
        }
            AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageUrl) { (image) in
                self.activityIndicator.isHidden = true
                self.imageView.image = image
                self.completedLabel.isHidden = true
                self.progressView.isHidden = true
                self.activityIndicator.stopAnimating()
            print("*********** END **************")
        }
    }
 
}
