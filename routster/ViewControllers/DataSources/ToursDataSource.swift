//
//  ToursDataSource.swift
//  routster
//
//  Created by codefuse on 12.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit

class ToursDataSource: NSObject {
    
    // MARK: - Typealias
    internal typealias CellType = TourTableViewCell
    internal typealias ModelType = Tour
    internal typealias DidSelectHandler = (_ value: ModelType) -> Void
    internal typealias UpdateUIHandler = (_ oldValue: [ModelType], _ newValue: [ModelType]) -> Void
    
    // MARK: - Properties
    private var dataSource: [ModelType] = [] {
        didSet {
            self.updateUIHandler?(oldValue, self.dataSource)
        }
    }
    private var didSelectHandler: DidSelectHandler?
    private var updateUIHandler: UpdateUIHandler?
    
    var hasContent: Bool {
        
        return !self.dataSource.isEmpty
    }
    
    func configure(tableView: UITableView) {
        
        tableView.register(cellType: CellType.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 86.0
    }
    
    func set(dataSource: [ModelType]) {
        
        self.dataSource = dataSource
    }
    
    // MARK: - Init
    init(didSelectHandler: DidSelectHandler?, updateUIHandler: UpdateUIHandler?) {
        
        self.didSelectHandler = didSelectHandler
        self.updateUIHandler  = updateUIHandler
    }
    
    // MARK: - Helper
    private func getModelType(indexPath: IndexPath) -> ModelType? {
        return self.dataSource[indexPath.row]
    }
}


// MARK: - UITableViewDataSource
extension ToursDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell   = tableView.dequeueReusableCell(for: indexPath) as CellType
        guard let item = self.getModelType(indexPath: indexPath) else {
            return cell
        }
        cell.model = item
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ToursDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
            let item = self.getModelType(indexPath: indexPath) else { return }
        self.didSelectHandler?(item)
        cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
    }
}
