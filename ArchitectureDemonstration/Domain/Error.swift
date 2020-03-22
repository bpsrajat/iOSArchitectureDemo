//
//  Error.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation

enum Error {
    case noLocalData
    
    var errorDescription: String {
       switch self {
       case .noLocalData: return "No local data found. Internet appears to be offline."
       }
   }
}
