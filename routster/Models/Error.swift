//
//  Error.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

class Error: Codable {
    let message: String
    let code: Int?
    let error: String?
}
