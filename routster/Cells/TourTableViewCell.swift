//
//  TourTableViewCell.swift
//  routster
//
//  Created by codefuse on 07.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import Reusable

class TourTableViewCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - Properties
    internal var model: Tour? {
        didSet {
            guard let model = model else { return }
            self.nameLabel.text = model.name
            self.infoLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((model.distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((model.duration/60/60).rounded(toPlaces: 2)) h \(String(format: "%C", UniChar(0xf1ae))): \(model.sport)"
            self.accessoryType = (model.isSelected == true) ? .checkmark : .none
        }
    }
}
