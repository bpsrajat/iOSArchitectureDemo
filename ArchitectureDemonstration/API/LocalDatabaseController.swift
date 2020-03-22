//
//  LocalDatabaseController.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation

class LocalDatabaseController {
 
    static let dbKey: String = "sKey"
    
    func saveToLocal(stories: ApiModel) {
        UserDefaults.standard.setValue(stories.toJSON(), forKey: LocalDatabaseController.dbKey)
    }
    
    func readFromLocal() -> ApiModel? {
        if let rawModel =  UserDefaults.standard.value(forKey: LocalDatabaseController.dbKey) as? [String: Any] {
            return ApiModel(JSON: rawModel)
        } else {
            return nil
        }
    }
}
