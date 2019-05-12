//
//  EndpointItem.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import Alamofire

enum EndpointItem {
    
    // MARK: Endpoints
    case login(email: String, password: String)
    case userTours(username: String, password: String)
}

// MARK: - Extensions
// MARK: - EndPointType
extension EndpointItem: EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        return "https://api.komoot.de/"
    }
    
    var path: String {
        switch self {
        case .login(let email, _):
            return "v006/account/email/\(email)/"
        case .userTours(let username, _):
            return "v006/users/\(username)/tours/todo?srid=4326"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .login(let email, let password):
            let auth = "\(email):\(password)".toBase64()
            
            return [
                "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
                "Authorization": "Basic \(auth)"
            ]
        case .userTours(let username, let password):
            let auth = "\(username):\(password)".toBase64()
            
            return [
                "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
                "Authorization": "Basic \(auth)"
            ]
        }
    }
    
    var url: URL {
        switch self {
        default:
            guard let url = URL(string: self.baseURL + self.path) else { fatalError() }
            return url
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}
