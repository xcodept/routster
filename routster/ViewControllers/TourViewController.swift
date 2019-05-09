//
//  TourViewController.swift
//  routster
//
//  Created by codefuse on 08.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

// MARK: - TourViewControllerDelegate
protocol TourViewControllerDelegate {
    
    func tourViewControllerWillClose(tour: Tour)
}

// MARK: - TourViewController
class TourViewController: UIViewController {

    // MARK: - Properties
    private var tour: Tour?
    private var routes: [Route]?
    private var dataSource: UITableViewDataSource?
    
    // MARK: - Outlets
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourDetailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.register(UINib(nibName: "RouteTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteCellReuseIdentifier")
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let routes = self.routes {
            print(routes)
            self.dataSource = TableViewDataSource.make(for: routes)
            self.tableView.dataSource = self.dataSource
            self.tableView.delegate = self
        }
        if let tour = self.tour {
            self.tourNameLabel.text = tour.name
            self.tourDetailLabel.text = "\(String(format: "%C", UniChar(0xf140))): \((tour.distance/1000).rounded(toPlaces: 2)) km \(String(format: "%C", UniChar(0xf017))): \((tour.duration/60/60).rounded(toPlaces: 2)) h \(String(format: "%C", UniChar(0xf1ae))): \(tour.sport)"
        }
    }
    
    // MARK: - Accessors
    internal func setTour(tour: Tour) {
        self.tour = tour
    }
    
    internal func setRoutes(routes: [Route]) {
        self.routes = routes
    }
    
    internal func addRoute(route: Route) {
        if self.routes != nil {
            self.routes?.append(route)
        } else {
            self.routes = [route]
        }
    }
    
    // MARK: - Action methods
    @IBAction func closeButtonDidClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            //
        }
    }
}

// MARK: - UITableViewDelegate
extension TourViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let routes = self.routes, routes.count > indexPath.row {
            let route = routes[indexPath.row]
            let navigationViewController = NavigationViewController(for: route)
            self.present(navigationViewController, animated: true) {
                //
            }
        }
    }
}
