//
//  RouteTableViewCell.swift
//  routster
//
//  Created by codefuse on 08.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import MapboxDirections

class RouteTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var routeInfoLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Methods
    public func setRoute(distance: Double, duration: Double) {
        self.routeInfoLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((duration/60/60).rounded(toPlaces: 2)) h"
    }
    
    // MARK: - Action methods
}
