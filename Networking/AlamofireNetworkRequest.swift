//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Felix Falkovsky on 29.09.2020.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, completion: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }

        AF.request(url, method: .get).validate().responseJSON { ( response ) in
           print(response)
            switch response.result {
            case .success(let value):
               print(value)
                
                guard let arrayOfItems = value as? Array<[String: Any]> else { return }
                
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
}
