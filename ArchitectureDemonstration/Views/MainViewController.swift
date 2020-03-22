//
//  MainViewController.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import UIKit
import SwiftMessages

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter: StoriesPresenterProtocol!
    let cellName = "StoryTableViewCell"
    let refreshControl = UIRefreshControl()
    var emptyStateLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .white)
    let footerIndicator = UIActivityIndicatorView(style: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        presenter = StoriesPresenter.init(listener: self)
        activityIndicator.startAnimating()
        initialFetch()
        addErrorLabel()
    }
    
    func setupTableview() {
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9363937378, green: 0.9412893653, blue: 0.9454538226, alpha: 1)
        tableView.separatorStyle = .none
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        footerIndicator.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(38))
        footerIndicator.color = .darkGray
        footerIndicator.stopAnimating()
        
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(initialFetch), for: .allEvents)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }
    }
    
    func addErrorLabel() {
        emptyStateLabel.textColor = .darkGray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 20)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        tableView.addSubview(emptyStateLabel)
        emptyStateLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        emptyStateLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 28).isActive = true
        emptyStateLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 28).isActive = true
        emptyStateLabel.isHidden = true
    }
    
    @objc func initialFetch() {
        presenter.fetchStories(requestType: .initial)
    }
    
    func stopSpinners() {
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
        footerIndicator.stopAnimating()
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.createTableViewCell(tableView: tableView, indexPath: indexPath, story: presenter.datasource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if presenter.loadMore(indexPath: indexPath) {
            footerIndicator.startAnimating()
            self.tableView.tableFooterView = footerIndicator
            self.tableView.tableFooterView?.isHidden = false
        }
    }
}

extension MainViewController: StoriesPresenterListener {
    func onDataFetch() {
        stopSpinners()
        emptyStateLabel.isHidden = true
    }
    
    func onDataFetchError(errorString: String) {
        stopSpinners()
        emptyStateLabel.text = errorString
        emptyStateLabel.isHidden = false
    }
    
    func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
