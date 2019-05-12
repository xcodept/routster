//
//  Tour.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

struct Tour: Codable {
    let id: Int
    let name: String
    let startpoint: Point
    let distance: Double
    let duration: Double
    let sport: String
    var isSelected: Bool?
}
