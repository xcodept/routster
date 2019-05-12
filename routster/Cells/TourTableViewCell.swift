//
//  TourTableViewCell.swift
//  routster
//
//  Created by codefuse on 07.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit

class TourTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourInfoLabel: UILabel!
    
    // MARK: - Properties

    // MARK: - Methods
    public func set(name: String, distance: Double, duration: Double, sport: String, isSelected: Bool?) {
        self.tourNameLabel.text = name
        self.tourInfoLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((duration/60/60).rounded(toPlaces: 2)) h \(String(format: "%C", UniChar(0xf1ae))): \(sport)"
        self.accessoryType = (isSelected == true) ? .checkmark : .none
    }
}
