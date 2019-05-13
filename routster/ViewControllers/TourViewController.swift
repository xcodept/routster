//
//  TourViewController.swift
//  routster
//
//  Created by codefuse on 08.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import MapboxNavigation
import MapboxDirections

// MARK: - TourViewController
class TourViewController: RoutsterViewController {
    
    // MARK: - Lazy
    private lazy var dataSource: TourDataSource = {
        
        return TourDataSource(didSelectHandler: { [weak self] (item) in
                let navigationViewController = NavigationViewController(for: item)
                self?.present(navigationViewController, animated: true, completion: nil)
            }, updateUIHandler: { [weak self] (_, _) in
                self?.tableView.reloadData()
        })
    }()

    // MARK: - Properties
    internal var tour: Tour?
    
    // MARK: - Outlets
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourDetailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.dataSource.configure(tableView: self.tableView)
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let routes = self.tour?.routes {
            self.dataSource.set(dataSource: routes)
        }
        if let tour = self.tour {
            self.tourNameLabel.text = tour.name
            self.tourDetailLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((tour.distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((tour.duration/60/60).rounded(toPlaces: 2)) h \(String(format: "%C", UniChar(0xf1ae))): \(tour.sport)"
        }
    }
    
    // MARK: - Action methods
    @IBAction func closeButtonDidClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
