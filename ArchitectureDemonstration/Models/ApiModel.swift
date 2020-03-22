//
//  ApiModel.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiModel : Mappable {
	var stories : [Story] = []
	var nextUrl : String = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {

		stories <- map["stories"]
		nextUrl <- map["nextUrl"]
	}

}
