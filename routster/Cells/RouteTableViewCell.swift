//
//  RouteTableViewCell.swift
//  routster
//
//  Created by codefuse on 08.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import MapboxDirections
import Reusable

class RouteTableViewCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    @IBOutlet weak var routeInfoLabel: UILabel!
    
    // MARK: - Properties
    internal var model: Route? {
        didSet {
            guard let model = model else { return }
            self.routeInfoLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((model.distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((model.expectedTravelTime/60/60).rounded(toPlaces: 2)) h"
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    // MARK: - Action methods
}
