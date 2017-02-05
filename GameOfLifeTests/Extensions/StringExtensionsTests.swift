//
//  StringExtensionsTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/5/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

class StringExtensionsTests: XCTestCase {
    func testTagsExpand() {
        let input = "bo2bo3o"
        let output = input.expandTags()
        let target = "bobboooo"
        XCTAssertEqual(output, target)
    }
    
    func testTagsCompress() {
        let input = "bobboooo"
        let output = input.compressTags()
        let target = "bo2b4o"
        XCTAssertEqual(output, target)
        
    }
}
