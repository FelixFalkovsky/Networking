//
//  WebsiteDescription.swift
//  Networking
//
//  Created by Felix Falkovsky on 27.09.2020.
//

import Foundation


struct WebsiteDescription: Decodable {
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
