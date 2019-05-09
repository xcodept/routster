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
class ToursViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.register(UINib(nibName: "TourTableViewCell", bundle: nil), forCellReuseIdentifier: "TourCellReuseIdentifier")
        }
    }
    
    // MARK: - Properties
    internal var tours: [Tour]?
    private var dataSource: UITableViewDataSource?
    
    internal var delegate: ToursViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tours = self.tours {
            print(tours)
            self.dataSource = TableViewDataSource.make(for: tours)
            self.tableView.dataSource = self.dataSource
            self.tableView.delegate = self
        }
    }
    
    // MARK: - Action methods
    @IBAction func closeButtonDidClicked(_ sender: Any) {
        self.delegate?.toursViewControllerWillClose(tours: self.tours)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension ToursViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 86.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let count = self.tours?.count, count > indexPath.row {
            if let isSelected = self.tours?[indexPath.row].isSelected, isSelected == true {
                self.tours?[indexPath.row].isSelected = false
                cell.accessoryType = .none
            } else {
                self.tours?[indexPath.row].isSelected = true
                cell.accessoryType = .checkmark
            }
        }
    }
}
