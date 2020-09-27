//
//  MainViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 27.09.2020.
//

import UIKit

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCurses = "Our Courses"
    case uploadImage = "Upload Image"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"

class MainViewController: UICollectionViewController {
    
    //let actions = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]
    let actions = Actions.allCases

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
            print("Upload Image")
        }
    }

}
