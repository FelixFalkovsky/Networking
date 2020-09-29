//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Felix Falkovsky on 29.09.2020.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        guard let url = URL(string: url) else { return }

        AF.request(url, method: .get).validate().responseJSON { ( response ) in
           print(response)
            switch response.result {
            case .success(let value):
                print(value)
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
}
