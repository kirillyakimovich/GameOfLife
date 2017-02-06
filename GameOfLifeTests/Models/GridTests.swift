//
//  GridTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/3/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GridTests: XCTestCase {
    var grid = Grid([[1, 2], [3, 4], [5, 6]])
    
    func testSubscriptForFirstElement() {
        XCTAssertEqual(grid[0, 0], 1)
    }
    
    func testSubscriptForLastElement() {
        XCTAssertEqual(grid[1, 2], 6)
    }
    
    func testAnotherSubscript() {
        grid[0, 1] = -10
        XCTAssertEqual(grid, Grid([[1, -10], [3, 4], [5, 6]]))
    }
    
    func testGetRowSubscript() {
        XCTAssertEqual(grid[row: 2], [5, 6])
    }
    
    func testSetRowSubscript() {
        grid[row: 2] = [-7, -8]
        XCTAssertEqual(grid, Grid([[1, 2], [3, 4], [-7, -8]]))
    }
    
    func testGetColumnSubscript() {
        XCTAssertEqual(grid[column: 0], [1, 3, 5])
    }
    
    func testSetColumnSubscript() {
        grid[column: 0] = [-7, -8, -9]
        XCTAssertEqual(grid, Grid([[-7, 2], [-8, 4], [-9, 6]]))
    }
    
    func testBackwardCycledSubscript() {
        XCTAssertEqual(grid[cycledRow: -1, cycledColumn: -1], 6)
    }
    
    func testForwardCycledSubscript() {
        XCTAssertEqual(grid[cycledRow: 100, cycledColumn: 100], 1)
    }

    func testContainsReturnsTrueForPresetnElement() {
        XCTAssertTrue(grid.contains(3))
    }
    
    func testContainsReturnsFalseForAbsentElement() {
        XCTAssertFalse(grid.contains(300))
    }
    
    func testInitWithContentsWidthHeightDefault() {
        let grid = Grid(from: [[0], [1], [2, 3, 4]], width: 4, height: 4, default: -1)
        let targetGrid = Grid([[0, -1, -1, -1], [1, -1, -1, -1], [2, 3, 4, -1], [-1, -1, -1, -1]])
        XCTAssertEqual(grid, targetGrid)
    }

}
