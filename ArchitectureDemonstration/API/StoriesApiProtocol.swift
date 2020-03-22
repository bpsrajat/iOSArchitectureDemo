//
//  StoriesApiProtocol.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation

// Protocols for api
protocol StoriesApiProtocol {
    func fetchStories(url: String)
}

// API delegates to domain
protocol StoriesApiListener: class {
    func onDataFetch(api: ApiModel)
    func onLocalDataFetch()
}
