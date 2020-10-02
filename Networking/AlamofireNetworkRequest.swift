//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Felix Falkovsky on 29.09.2020.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static var onProgress: ((Double)->())?
    static var complited: ((String)->())?
    
    //MARK: Send Request
    static func sendRequest(url: String, completion: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }

        AF.request(url, method: .get).validate().responseJSON { ( response ) in
           print(response)
            switch response.result {
            case .success(let value):
               print(value)
                
               // guard let arrayOfItems = value as? Array<[String: Any]> else { return }
                
                var courses = [Course]()
                
                courses = Course.getArray(from: value)!
                completion(courses)
                
                // for field in arrayOfItems {
                   // Исполнение 1
//                    let course = Course(id: field["id"] as? Int,
//                                        name: field["name"] as? String,
//                                        link: field["link"] as? String,
//                                        imageUrl: field["imageUrl"] as? String,
//                                        numberOfLessons: field["number_of_lessons"] as? Int,
//                                        numberOfTests: field["number_of_tests"] as? Int)
//                    courses.append(course)
                   // Исполнение 2
//                    guard let course = Course(json: field) else { return }
//                    courses.append(course)
              //  }
            //completion(courses)
            case .failure(let error):
                print(error)
            }
//            guard let statusCode = response.response?.statusCode else { return }
//            print("***Status code, \(statusCode)***")
//
//            if (200..<300).contains(statusCode) {
//                let value = response.value
//                print("value", value as Any)
//            } else {
//                let error = response.error
//                print("*** Error ", error as Any)
//            }
        }
    }
    //MARK: Response Data
    static func responsData(url: String) {
        AF.request(url).response { (responsData) in
            switch responsData.result {
            case .success(let data):
                guard let string = String(data: data!, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    //MARK: Response String
    static func responseString(url: String) {
        AF.request(url).response { (responseString) in
            switch responseString.result {
            case .success(let string):
                print(string as Any)
            case .failure(let error):
                print(error)
            }
        }
    }
    static func response(url: String) {
        AF.request(url).response { (response) in
            guard let data = response.data, let string = String(data: data, encoding: .utf8) else { return }
            print(string)
            
        }
    }
    static func downloadImageWithProgress(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
        AF.request(url).validate().downloadProgress { (progress) in
            print("***Start Downloads***")
            print("TotalUnutCount:\n", progress.totalUnitCount)
            print("Complited Unit Count:\n", progress.completedUnitCount)
            print("Fraction Complited:\n", progress.fractionCompleted)
            print("Localize Description:\n", progress.localizedDescription!)
            print("*****************************************************")
            self.onProgress?(progress.fractionCompleted)
            self.complited?(progress.localizedDescription)
        }.response { (response) in
            guard let data = response.data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    // Запрос на добавление поста // Alamofire
    static func postRequest(url: String, completion: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        let  userData: [String: Any] = [
            "name": "Network Request",
            "link": "https://swiftbook.ru/contents/our-first-applications/",
            "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
            "numberOfLessons": 18,
            "numberOfTests": 10
        ]
        AF.request(url, method: .post, parameters: userData).responseJSON { (responsJSON) in
            guard let statusCode = responsJSON.response?.statusCode else { return }
            print("status Code", statusCode)
            
            switch responsJSON.result {
            case .success(let value):
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject) else { return }
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    // Запрос для put // Alamofire
    // Запрос на добавление поста // Alamofire
    static func putRequest(url: String, completion: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        let  userData: [String: Any] = [
            "name": "Network Request with Alamofire",
            "link": "https://swiftbook.ru/contents/our-first-applications/",
            "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
            "numberOfLessons": "18",
            "numberOfTests": "10"
        ]
        AF.request(url, method: .put, parameters: userData).responseJSON { (responsJSON) in
            guard let statusCode = responsJSON.response?.statusCode else { return }
            print("status Code", statusCode)
            
            switch responsJSON.result {
            case .success(let value):
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject) else { return }
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    //
    static func uploadImage(url: String) {
//        guard let url = URL(string: url) else { return }
//        let image = UIImage(named: "github")!
//        let data = image.pngData()!
//
//        let httpHeaders: HTTPHeaders = ["Authorization" : "Client-ID 124bdab951636cc"]
//
//        AF.upload(multipartFormData: { (multipadFormData) in
//            multipadFormData.append(data, withName: "image") //  - данный метод не подходит при выгрузке видео контента !
//        }, to: url, headers: httpHeaders) { (response) in
//
//            switch response {
//            case .success(request: let uploadRequest,
//                          streamingFromDisk: let streamingFromDisk,
//                          streamFileURL: let streamFileURL):
//            print(uploadRequest)
//            print(streamingFromDisk)
//            print(streamFileURL)
//
//                uploadRequest.validate().responseJSON(completionHandler: { (responseJSON) in
//                    switch responseJSON.result {
//                    case .success(let wow):
//                        print(wow)
//                    case .failure(let error):
//                        print(error)
//                    }
//                })
//            case .failure(let error):
//                print(error)
//            }
//
//        }
    }
}
