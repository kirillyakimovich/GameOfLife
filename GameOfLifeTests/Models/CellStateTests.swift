//
//  CellStateTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/5/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

class CellStateTests: XCTestCase {
    func testInitWithInvalidRLETag() {
        XCTAssertEqual(CellState(rleTag: "asdf"), .dead)
    }
    
    func testInitWithValidRLEDeadTag() {
        XCTAssertEqual(CellState(rleTag: "b"), .dead)
    }
    
    func testInitWithValidRLEAliveTag() {
        XCTAssertEqual(CellState(rleTag: "o"), .alive)
    }
}
