//
//  StoriesPresenter.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import UIKit
import SwiftMessages

class StoriesPresenter: StoriesPresenterProtocol {
    
    var domain: StoriesDomainProtocol!
    weak var presenterListener: StoriesPresenterListener?
    let cellName = "StoryTableViewCell"
    var hasFetchFailed = false
    var requestType: RequestType = .initial
    let messageView = MessageView.viewFromNib(layout: .cardView)
    var datasource = [Story]() {
        didSet {
            presenterListener?.refreshTableView()
        }
    }

    init(listener: StoriesPresenterListener) {
        presenterListener = listener
        domain = StoriesDomain(listener: self)
    }
    
    // Presenter fetch logic. Resets the datasource if its the initial fetch or a refresh
    func fetchStories(requestType: RequestType) {
        self.requestType = requestType
        switch self.requestType {
        case .initial:
            datasource = []
        case .nextpage:
            break
        }
        domain.fetchStories(requestType: requestType)
    }
    
    // Infinite scroll logic
    func loadMore(indexPath: IndexPath) -> Bool{
        if hasFetchFailed { return false }
        if indexPath.row == datasource.count - 1 {
            fetchStories(requestType: .nextpage)
            return true
        }
        return false
    }
    
    func createTableViewCell(tableView: UITableView, indexPath: IndexPath, story: Story) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! StoryTableViewCell
        cell.setCell(story: story)
        return cell
    }
    
    // Shows message when user is browsing in offline mode.
    func showMessage() {
        messageView.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.dimMode = .none
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        messageView.configureTheme(backgroundColor: #colorLiteral(red: 1, green: 0.3815449476, blue: 0.1356335878, alpha: 1), foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
        messageView.configureContent(title: "You are browsing in offline mode.", body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in SwiftMessages.hide() })
        SwiftMessages.show(config: config, view: messageView)
    }
}

extension StoriesPresenter: StoriesDomainListener {
    func onDataFetch(stories: [Story], isLocal: Bool) {
        // Prevents infinite scroll from fetching if is loading local data
        hasFetchFailed = isLocal ? true : false
        if isLocal {
            // MARK: Made the assumption that if fetch fails, defaults to the 10 items cached for offline mode to keep the experience consistence. Trade off is users lost the items not cached
            showMessage()
            datasource = stories
        } else {
            // MARK: Sometimes the first few items the api returns are duplicates from previous fetch. Made the assumption that this is a server side issue, so did not implement client side logic to remove the duplicated items.
            datasource.append(contentsOf: stories)
        }
        presenterListener?.onDataFetch()
    }
    
    func onDataFetchError(errorString: String) {
        hasFetchFailed = true
        presenterListener?.onDataFetchError(errorString: errorString)
    }
}
