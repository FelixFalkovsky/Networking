//
//  MainViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 27.09.2020.
//

import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCurses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case ourCoursesAlamofire = "Our Courses (Alamofire)"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"

class MainViewController: UICollectionViewController {
    
    //let actions = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        registerForNotification()
        super.viewDidLoad()
        dataProvider.fileLocation = { (location) in
            //..Сохраняем файл для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
    }
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        let height = NSLayoutConstraint(
            item: alert.view as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0,
            constant: 170)
        alert.view.addConstraint(height)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        present(alert, animated: true) {
        
        let size = CGSize(width: 40, height: 40)
        let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2,
                            y: self.alert.view.frame.height / 2 - size.height / 2)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 4))
            progressView.tintColor = .blue
        progressView.progress = 0.0
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.label.text = actions[indexPath.row].rawValue
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url )
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCurses:
            performSegue(withIdentifier: "Our Courses", sender: self)
            print("Our Courses")
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
            print(action.rawValue)
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "OurCoursesWithAlomofire", sender: self)
            print(action.rawValue)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        switch segue.identifier {
        case "Our Courses":
            coursesVC?.fetchData()
            print("Our Courses")
        case "OurCoursesWithAlomofire":
            coursesVC?.fetchDataWithAlamofire()
            print("OurCoursesWithAlomofire")
        default:
            break
        }
    }
}

extension MainViewController {
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
             
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your backgraund transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
