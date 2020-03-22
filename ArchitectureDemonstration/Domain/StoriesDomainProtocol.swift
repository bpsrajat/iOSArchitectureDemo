//
//  StoriesDomainProtocol.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation

// Protocols for domain
protocol StoriesDomainProtocol {
    func fetchStories(requestType: RequestType)
}

// Domain delegates to presenter
protocol StoriesDomainListener: class {
    func onDataFetch(stories: [Story], isLocal: Bool)
    func onDataFetchError(errorString: String)
}
