//
//  Course.swift
//  Networking
//
//  Created by Felix Falkovsky on 26.09.2020.
//

import Foundation

 // Исполнение 1
//struct Course: Decodable {
//    let id: Int?
//    let name: String?
//    let link: String?
//    let imageUrl: String?
//    let numberOfLessons: Int?
//    let numberOfTests: Int?
//}
// Исполнение 2
struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: String? //Int
    let numberOfTests: String? //Int
    
    init?(json:[String: Any]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["numberOfLessons"] as? String //Int
        let numberOfTests = json["numberOfTests"] as? String //Int
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
    }
    
    static func getArray(from jsonArray: Any) -> [Course]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        
//        var courses: [Course] = []
//        for jsonObject in jsonArray {
//            if let course = Course(json: jsonObject) {
//                courses.append(course)
//            }
//        }
        return jsonArray.compactMap{ Course(json: $0) }
    }
}
