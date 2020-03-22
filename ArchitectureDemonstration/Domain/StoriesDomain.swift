//
//  StoriesDomain.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation

class StoriesDomain: StoriesDomainProtocol {
    
    var api: StoriesApiProtocol!
    weak var domainListener: StoriesDomainListener?
    let localDBController = LocalDatabaseController()
    var isEndOfPage = false
    var isFetchInProgress = false
    var requestType: RequestType = .initial
    var url: String = ""
    
    init(listener: StoriesDomainListener) {
        api = StoriesApi(listener: self)
        domainListener = listener
    }
    
    // Initial fetch uses the the hardcoded url. Subsequent fetch will use the next url provided by the api.
    func setupCurrentPage(requestType: RequestType) {
        switch requestType {
        case .initial: self.url = "local"
        case .nextpage: break
        }
    }
    
    func fetchStories(requestType: RequestType) {
        self.requestType = requestType
        
        if requestType == .initial {
            isEndOfPage = false
        }
        
        if isFetchInProgress || isEndOfPage {
            return
        }
        
        isFetchInProgress = true
        setupCurrentPage(requestType: requestType)
        api.fetchStories(url: url)
    }
}

extension StoriesDomain: StoriesApiListener {

    func onDataFetch(api: ApiModel) {
        if api.stories.isEmpty {
            isEndOfPage = true
        }   
        
        // MARK: The assumption here is that we are not constructing our own url by increase the page offset because nextUrl is provided in the JSON.
        self.url = api.nextUrl
        // Caches the first 10 items fetched.
        if requestType == .initial {
            localDBController.saveToLocal(stories: api)
        }
        domainListener?.onDataFetch(stories: api.stories, isLocal: false)
        isFetchInProgress = false
    }
    
    
    func onLocalDataFetch() {
        // MARK: The assumption here is that we are only showing the cached stories when the fetch fails, but not showing it everytime before an intial fetch regardless of outcome. The trade off is that we are not taking of the caching to speed up load time. Having said that, the api returns different stories every fetch, this would avoid confusion with stories changing after the call succeeds.
        if let model = localDBController.readFromLocal() {
            domainListener?.onDataFetch(stories: model.stories, isLocal: true)
        } else {
            domainListener?.onDataFetchError(errorString: Error.noLocalData.errorDescription)
        }
        isFetchInProgress = false
    }
}
