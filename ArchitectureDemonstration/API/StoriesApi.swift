//
//  StoriesApi.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class StoriesApi: StoriesApiProtocol {
    
    weak var apiListener: StoriesApiListener?
    
    init(listener: StoriesApiListener) {
        apiListener = listener
    }
    
//    func fetchStories(url: String) {
//        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding(), headers: nil).responseObject { (response: DataResponse<ApiModel>) in
//            switch response.result {
//            case .success(_):
//                // MARK: Made the assumption that server will return valid json.
//                if let resp = response.result.value {
//                    self.apiListener?.onDataFetch(api: resp)
//                }
//            case .failure(let error):
//                // API fails, ask domain to check DB for cache data.
//                self.apiListener?.onLocalDataFetch()
//                return
//            }
//        }
//    }
    
    func fetchStories(url: String) {
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
