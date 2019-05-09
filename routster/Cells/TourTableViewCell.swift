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
    public func setTour(tour: Tour) {
        self.tourNameLabel.text = tour.name
        self.tourInfoLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((tour.distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((tour.duration/60/60).rounded(toPlaces: 2)) h \(String(format: "%C", UniChar(0xf1ae))): \(tour.sport)"
        self.accessoryType = (tour.isSelected == true) ? .checkmark : .none
    }
}
