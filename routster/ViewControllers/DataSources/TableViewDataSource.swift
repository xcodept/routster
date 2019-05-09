//
//  TableViewDataSource.swift
//  routster
//
//  Created by codefuse on 07.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import Foundation
import UIKit
//import Mapbox
//import MapboxCoreNavigation
//import MapboxNavigation
import MapboxDirections

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    
    // MARK: - Typealiases
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    // MARK: - Properties
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    // Mark: - Initialization
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    // MARK: - DataSource protocol
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        cellConfigurator(model, cell)
        
        return cell
    }
}

// MARK: - Tour models
extension TableViewDataSource where Model == Tour {
    static func make(for tours: [Tour],
                     reuseIdentifier: String = "TourCellReuseIdentifier") -> TableViewDataSource {
        
        return TableViewDataSource(
            models: tours,
            reuseIdentifier: reuseIdentifier) { (tour, cell) in
                if let cell = cell as? TourTableViewCell {
                    cell.setTour(tour: tour)
                }
        }
    }
}

// MARK: - Route models
extension TableViewDataSource where Model == Route {
    static func make(for routes: [Route],
                     reuseIdentifier: String = "RouteCellReuseIdentifier") -> TableViewDataSource {
        
        return TableViewDataSource(
            models: routes,
            reuseIdentifier: reuseIdentifier) { (route, cell) in
                if let cell = cell as? RouteTableViewCell {
                    cell.setRoute(distance: route.distance, duration: route.expectedTravelTime)
                }
        }
    }
}
