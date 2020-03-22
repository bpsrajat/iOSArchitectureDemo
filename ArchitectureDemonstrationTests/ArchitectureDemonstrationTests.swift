//
//  ArchitectureDemonstrationTests.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import XCTest
@testable import ArchitectureDemonstration

class ArchitectureDemonstrationTests: XCTestCase {
    var api: StoriesApiProtocol!
    var localData: ApiModel?
    
    override func setUp() {
        api = MockApi(listener: self)
        api.fetchStories(url: "local")
    }
    
    func testModelStructure() {
        XCTAssertNotNil(localData)
    }
    
    func testStoryDataMapping() {
        if let local = localData {
            XCTAssertEqual(local.stories[0].id, "212052492")
            XCTAssertEqual(local.stories[0].title, "bill x dipper")
        }
    }
    
    func testUserDataMapping() {
        if let local = localData {
            let userData = local.stories[0].user
            XCTAssertEqual(userData.name, "sinister_shipper")
            XCTAssertEqual(userData.fullname, "sinister_shipper")
        }
    }
    
    func testNextURL() {
        if let local = localData {
            let firstNextUrl = local.nextUrl
             XCTAssertEqual(firstNextUrl, "local")
        }
    }
    
    func testAllStoriesMapped() {
        if let local = localData {
            XCTAssertEqual(local.stories.count, 10)
        }
    }
}

extension ArchitectureDemonstrationTests: StoriesApiListener {
    func onLocalDataFetch() {}

    func onDataFetch(api: ApiModel) {
        // Passing the mock api data for testcase
        localData = api
        XCTAssert(true)
    }
}

