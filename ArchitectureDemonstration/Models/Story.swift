//
//  Story.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation
import ObjectMapper

class Story : Mappable {
	var id : String = ""
	var title : String = ""
    var user: User = User()
	var cover : String = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
		id <- map["id"]
		title <- map["title"]
		user <- (map["user"])
		cover <- map["cover"]
	}

}
