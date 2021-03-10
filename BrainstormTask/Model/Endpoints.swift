//
//  Endpoints.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import Foundation

struct API {
    static let baseUrl = "https://randomuser.me/"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {

    enum Get: Endpoint {
        
        case user
        var path: String {
            return "api"
        }
        
        var url: String {
            return "\(API.baseUrl)\(path)"
        }
    }
}
