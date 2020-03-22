//
//  User.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable {
	var name : String = ""
	var fullname : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
		name <- map["name"]
		fullname <- map["fullname"]
	}

}
