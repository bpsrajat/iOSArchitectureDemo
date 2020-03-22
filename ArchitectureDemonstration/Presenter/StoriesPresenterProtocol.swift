//
//  StoriesPresenterProtocol.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import UIKit

// Protocols for presenter
protocol StoriesPresenterProtocol {
    var datasource: [Story] { get }
    func fetchStories(requestType: RequestType)
    func createTableViewCell(tableView: UITableView, indexPath: IndexPath, story: Story) -> UITableViewCell
    func loadMore(indexPath: IndexPath) -> Bool
}

// Presenter delegates to view controller
protocol StoriesPresenterListener: class {
    func onDataFetch()
    func onDataFetchError(errorString: String)
    func refreshTableView()
}
