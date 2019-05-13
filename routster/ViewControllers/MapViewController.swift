//
//  MapViewController.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxDirections

class MapViewController: RoutsterViewController {
    
    // MARK: - Typealis
    typealias CompletionTours = (APIManager.ToursResult) -> Void
    
    // MARK: - Properties
    private var tours: [Tour]?    {
        didSet {
            guard let selectedTours = self.tours?.filter( {$0.isSelected == true} ) else { return }
            self.messageView.isHidden = selectedTours.count > 0 ? true : false
        }
    }
    fileprivate var updatedUserLocation = false
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MGLMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.mapView.zoomLevel = 5
            self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 52.390569, longitude: 13.064473) // Location: Potsdam
        }
    }
    @IBOutlet weak var messageView: UIView! {
        didSet {
            self.messageView.isHidden = true
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            self.messageLabel.text = L10n.messageLabelText
        }
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configureView()
    }
    
    // MARK: - Configure methods
    private func configureView() {
        if let username = UserDefaultsService.id, let password = UserDefaultsService.password {
            // User is authenticated
            if let _ = self.tours {
                self.hideUnselectedTours()
                self.displaySelectedTours()
            } else {
                self.loadTours(username: username, password: password) { [weak self]  (toursResult) in
                    switch toursResult {
                    case .success(let tours):
                        self?.tours = tours
                        self?.hideUnselectedTours()
                        self?.displaySelectedTours()
                    case .error(let error):
                        guard let code = error.code, let errorMessage = error.error else  {
                            AlertMessageService.showAlertBottom(title: L10n.error.capitalized, body: error.message, icon: "", theme: .error)
                            return
                        }
                        AlertMessageService.showAlertBottom(title: "\(L10n.error.capitalized): \(code)/\(errorMessage)", body: error.message, icon: "", theme: .error)
                    }
                }
            }
        } else {
            // User is not authenticated
            self.performSegue(withIdentifier: StoryboardSegue.Main.presentLoginViewController.rawValue, sender: self)
        }
    }
    
    // MARK: - Tour methods
    // MARK: -- Data
    private func loadTours(username: String, password: String, completion: @escaping CompletionTours) {
        
        APIManager.shared.userTours(username: username, password: password) { (tourResult) in
            completion(tourResult)
        }
    }
    
    // MARK: -- UI
    private func displaySelectedTours() {
        
        guard let userLocationCoordinate = self.mapView.userLocation?.coordinate, CLLocationCoordinate2DIsValid(userLocationCoordinate) == true else {
            AlertMessageService.showAlertBottom(title: L10n.error.capitalized, body: L10n.locationAccess, icon: "📍", theme: .error)
            return
        }
        
        guard let tours = self.tours else { return }
        for tour in tours where tour.isSelected == true {
            if let _ = tour.routes {
                self.drawTour(tour: tour)
            } else {
                let destinationLocationCoordinate = CLLocationCoordinate2D(latitude: tour.startpoint.y, longitude: tour.startpoint.x)
                self.calculateRoute(from: userLocationCoordinate,
                                    to: destinationLocationCoordinate,
                                    completion: { [unowned self] (routes, error) in
                                        if let routes = routes {
                                            guard var tours = self.tours, let index = tours.firstIndex(where: {$0.id == tour.id}) else { return }
                                            tours[index].routes = routes
                                            self.tours = tours
                                            self.drawTour(tour: tours[index])
                                        } else if let error = error {
                                            AlertMessageService.showAlertBottom(title: L10n.error.capitalized, body: "\(L10n.unexpectedError) - \(error.localizedDescription)", icon: "🦠", theme: .error)
                                        } else {
                                            // TODO: - error handling
                                        }
                })
            }
        }
    }
    
    private func hideUnselectedTours() {
        guard let tours = self.tours else { return }
        for tour in tours where tour.isSelected == false {
            self.undrawTour(tour: tour)
        }
    }
    
    // MARK: - Route methods
    // MARK: -- Data
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping ([Route]?, NSError?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { (waypoints, routes, error) in
            completion(routes, error)
        }
    }
    
    // MARK: -- UI
    internal func drawTour(tour: Tour) {
        
        guard let routes = tour.routes else { return }
        
        let randomColor = UIColor.randomColor
        let point = MGLPointAnnotation()
        point.title = tour.name
        point.coordinate = CLLocationCoordinate2D(latitude: tour.startpoint.y, longitude: tour.startpoint.x)
        self.mapView.addAnnotation(point)
        
        for (index, route) in routes.enumerated() {
            guard let routeCoordinates = route.coordinates else { return }
            
            let polyline = MGLPolylineFeature(coordinates: routeCoordinates, count: route.coordinateCount)
            let routeIdentifier = "route-\(tour.id)-\(index)"
            
            if let source = self.mapView.style?.source(withIdentifier: routeIdentifier) as? MGLShapeSource {
                source.shape = polyline
            } else {
                let source = MGLShapeSource(identifier: routeIdentifier, features: [polyline], options: nil)
                let lineStyle = MGLLineStyleLayer(identifier: routeIdentifier, source: source)
                lineStyle.lineColor = NSExpression(forConstantValue: randomColor.withAlphaComponent(1.0 / CGFloat(index)))
                lineStyle.lineWidth = NSExpression(forConstantValue: 3)
                
                self.mapView.style?.addSource(source)
                self.mapView.style?.addLayer(lineStyle)
            }
        }
    }

    func undrawTour(tour: Tour) {
        guard let routes = tour.routes else { return }
        for (index, _) in routes.enumerated() {
            let routeIdentifier = "route-\(tour.id)-\(index)"
            guard let source = self.mapView.style?.source(withIdentifier: routeIdentifier),
                let layer = self.mapView.style?.layer(withIdentifier: routeIdentifier) else {
                return
            }
            self.mapView.style?.removeSource(source)
            self.mapView.style?.removeLayer(layer)
            
            let annotations = self.mapView.annotations?.filter({$0.coordinate == CLLocationCoordinate2D(latitude: tour.startpoint.y, longitude: tour.startpoint.x)})
            annotations?.forEach({ (annotation) in
                self.mapView.removeAnnotation(annotation)
            })
        }
    }
    
    // MARK: - Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toursViewController = segue.destination as? ToursViewController {
            toursViewController.tours = self.tours
            toursViewController.delegate = self
        } else if let tourViewController = segue.destination as? TourViewController, let tour = sender as? Tour {
            tourViewController.tour = tour
        }
    }
    
    // MARK: - Action methods
    @IBAction func toursButtonDidClicked(_ sender: Any) {
        self.performSegue(withIdentifier: StoryboardSegue.Main.presentToursViewController.rawValue, sender: self)
    }
    
    @IBAction func logoutButtonDidClicked(_ sender: Any) {
        AlertMessageService.showAlertBottom(title: L10n.note.capitalized, body: L10n.loggedOutSuccessfully, icon: "🚪", theme: .info)
        UserDefaultsService.removeUserInformation()
        self.configureView()
    }
}

// MARK: - ToursViewControllerDelegate
extension MapViewController: ToursViewControllerDelegate {
    
    func toursViewControllerWillClose(tours: [Tour]?) {
        self.tours = tours
    }
}

// MARK: - MGLMapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    
    // - User Location
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard self.updatedUserLocation == false else { return }
        guard let userCoordinate = userLocation?.coordinate, CLLocationCoordinate2DIsValid(userCoordinate) == true else { return }
        mapView.centerCoordinate = userCoordinate
        self.updatedUserLocation = true
    }
    
    // - Annotations
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let filteredTours = self.tours?.filter( { CLLocationCoordinate2D(latitude: $0.startpoint.y, longitude: $0.startpoint.x) == annotation.coordinate } ), let filteredTour = filteredTours.first else { return }
        self.performSegue(withIdentifier: StoryboardSegue.Main.presentTourViewController.rawValue, sender: filteredTour)
    }
}

