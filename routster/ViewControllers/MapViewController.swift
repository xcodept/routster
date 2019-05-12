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
    typealias CompletionTours = ([Tour]?, Error?) -> Void
    typealias AliasRoute = (tour: Tour, route: Route, sourceIdentifier: String, layerIdentifier: String)
    
    // MARK: - Properties
    private var tours: [Tour]?    {
        didSet {
            guard let selectedTours = self.tours?.filter( {$0.isSelected == true} ) else { return }
            self.messageView.isHidden = selectedTours.count > 0 ? true : false
        }
    }
    private var routes = [AliasRoute]()
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
            if let tours = self.tours {
                self.hideUnselectedTours(tours: tours)
                self.displaySelectedTours(tours: tours)
            } else {
                self.loadTours(username: username, password: password) { (tours, error) in
                    if let tours = tours {
                        self.tours = tours
                        self.hideUnselectedTours(tours: tours)
                        self.displaySelectedTours(tours: tours)
                    } else if let error = error {
                        if let code = error.code, let errorMessage = error.error {
                            AlertMessageService.showAlertBottom(title: "\(L10n.error.localizedUppercase): \(code)/\(errorMessage)", body: error.message, icon: "", theme: .error)
                        } else {
                            AlertMessageService.showAlertBottom(title: L10n.error.localizedUppercase, body: error.message, icon: "", theme: .error)
                        }
                    } else {
                        // TODO: - error handling
                    }
                }
            }
        } else {
            // User is not authenticated
            self.performSegue(withIdentifier: "presentLoginViewController", sender: self)
        }
    }
    
    // MARK: - Tour methods
    // MARK: -- Data
    private func loadTours(username: String, password: String, completion: @escaping CompletionTours) {
        
        APIManager.shared.userTours(username: username, password: password) { (tours, error) in
            completion(tours, error)
        }
    }
    
    // MARK: -- UI
    private func displaySelectedTours(tours: [Tour]) {
        for tour in tours where tour.isSelected == true {
            let filteredRoutes = self.routes.filter( { $0.tour.id == tour.id } )
            if filteredRoutes.count == 0, let userLocationCoordinate = self.mapView.userLocation?.coordinate, CLLocationCoordinate2DIsValid(userLocationCoordinate) == true {
                let destinationCoordinate = CLLocationCoordinate2D(latitude: tour.startpoint.y, longitude: tour.startpoint.x)
                self.calculateRoute(from: userLocationCoordinate,
                                    to: destinationCoordinate,
                                    completion: { [unowned self] (routes, error) in
                                        if let routes = routes {
                                            self.drawTour(tour: tour, routes: routes)
                                        } else if let error = error {
                                            AlertMessageService.showAlertBottom(title: L10n.error.localizedUppercase, body: "\(L10n.unexpectedError) - \(error.localizedDescription)", icon: "🦠", theme: .error)
                                        } else {
                                            // TODO: - error handling
                                        }
                                        
//                                        if let lastTour = self.tours?.filter({$0.isSelected == true}).last, lastTour.id == tour.id {
//                                            if let annotations = self.mapView.annotations {
//                                                self.mapView.showAnnotations(annotations, animated: true)
//                                            }
//                                        }
                })
            } else if let userLocationCoordinate = self.mapView.userLocation?.coordinate, CLLocationCoordinate2DIsValid(userLocationCoordinate) == false {
                AlertMessageService.showAlertBottom(title: L10n.error.localizedUppercase, body: L10n.locationAccess, icon: "📍", theme: .error)
            }
        }
    }
    
    private func hideUnselectedTours(tours: [Tour]) {
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
    func drawTour(tour: Tour, routes: [Route]) {
        let randomColor = UIColor.randomColor
        
        let point = MGLPointAnnotation()
        point.title = tour.name
        point.coordinate = CLLocationCoordinate2D(latitude: tour.startpoint.y, longitude: tour.startpoint.x)
        self.mapView.addAnnotation(point)
        
        for route in routes {
            guard let routeCoordinates = route.coordinates else { return }
            let polyline = MGLPolylineFeature(coordinates: routeCoordinates, count: route.coordinateCount)
            
            let random = Int.random(in: 0 ..< Int.max)
            let sourceIdentifier = "route-source-\(tour.id)-\(random)"
            let styleIdentifier = "route-style-\(tour.id)-\(random)"
            if let source = self.mapView.style?.source(withIdentifier: sourceIdentifier) as? MGLShapeSource {
                source.shape = polyline
            } else {
                let source = MGLShapeSource(identifier: sourceIdentifier, features: [polyline], options: nil)
                
                let lineStyle = MGLLineStyleLayer(identifier: styleIdentifier, source: source)
                lineStyle.lineColor = NSExpression(forConstantValue: randomColor)
                lineStyle.lineWidth = NSExpression(forConstantValue: 3)
                
                self.mapView.style?.addSource(source)
                self.mapView.style?.addLayer(lineStyle)
            }
            
            self.routes.append((tour, route, sourceIdentifier, styleIdentifier))
        }
    }

    func undrawTour(tour: Tour) {
        let filteredRoutes = self.routes.filter( { $0.tour.id == tour.id } )
        filteredRoutes.forEach { (tour, route, sourceIdentifier, layerIdentifier) in
            guard let source = self.mapView.style?.source(withIdentifier: sourceIdentifier),
                let layer = self.mapView.style?.layer(withIdentifier: layerIdentifier) else {
                return
            }
            self.mapView.style?.removeSource(source)
            self.mapView.style?.removeLayer(layer)
            
            let annotations = self.mapView.annotations?.filter({$0.coordinate == CLLocationCoordinate2D(latitude: tour.startpoint.y, longitude: tour.startpoint.x)})
            annotations?.forEach({ (annotation) in
                self.mapView.removeAnnotation(annotation)
            })
        }
        self.routes.removeAll(where: { $0.tour.id == tour.id })
    }
    
    // MARK: - Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toursViewController = segue.destination as? ToursViewController {
            toursViewController.tours = self.tours
            toursViewController.delegate = self
        } else if let tourViewController = segue.destination as? TourViewController, let routes = sender as? [AliasRoute] {
            for route in routes {
                tourViewController.addRoute(route: route.route)
                tourViewController.setTour(tour: route.tour) // *not perforant, because the variable is overwritten several times.*
            }
        }
    }
    
    // MARK: - Action methods
    @IBAction func toursButtonDidClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "presentToursViewController", sender: self)
    }
    
    @IBAction func logoutButtonDidClicked(_ sender: Any) {
        AlertMessageService.showAlertBottom(title: L10n.note, body: L10n.loggedOutSuccessfully, icon: "🚪", theme: .info)
        
        UserDefaultsService.id = nil
        UserDefaultsService.password = nil
        UserDefaultsService.email = nil
        
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
        let filteredRoutes = self.routes.filter( { CLLocationCoordinate2D(latitude: $0.tour.startpoint.y, longitude: $0.tour.startpoint.x) == annotation.coordinate } )
        print(filteredRoutes)
        self.performSegue(withIdentifier: "presentTourViewController", sender: filteredRoutes)
    }
}

