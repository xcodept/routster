//
//  ToursViewController.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit

// MARK: - ToursViewControllerDelegate
protocol ToursViewControllerDelegate {
    
    func toursViewControllerWillClose(tours: [Tour]?)
}

// MARK: - ToursViewController
class ToursViewController: RoutsterViewController {

    // MARK: - Lazy
    private lazy var dataSource: ToursDataSource = {
        
        return ToursDataSource(didSelectHandler: { [weak self] (item) in
                guard var tours = self?.tours, let index = tours.firstIndex(where: {$0.id == item.id}) else { return }
                tours[index].isSelected = !tours[index].isSelected
                self?.tours = tours
            }, updateUIHandler: { [weak self] (_, _) in
                self?.tableView.reloadData()
        })
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.dataSource.configure(tableView: self.tableView)
        }
    }
    
    // MARK: - Properties
    internal var tours: [Tour]?
    internal var delegate: ToursViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tours = self.tours {
            self.dataSource.set(dataSource: tours)
        }
    }
    
    // MARK: - Action methods
    @IBAction func closeButtonDidClicked(_ sender: Any) {
        self.delegate?.toursViewControllerWillClose(tours: self.tours)
        self.dismiss(animated: true, completion: nil)
    }
}
