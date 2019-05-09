//
//  EndpointType.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol EndPointType {
    
    // MARK: - Properties
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    
}
