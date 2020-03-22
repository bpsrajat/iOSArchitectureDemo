//
//  MockApi.swift
//  ArchitectureDemonstrationTests
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation

class MockApi: StoriesApi {
    
    override func fetchStories(url: String?) {
            if let url = Bundle.main.url(forResource: url, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dictionary = object as? [String: AnyObject], let apiModel = ApiModel(JSON: dictionary) {
                        apiListener?.onDataFetch(api: apiModel)
                    }
                } catch {
                    print("Error!! Unable to parse  \(url).json")
                }
            }
    }
    
  
}
