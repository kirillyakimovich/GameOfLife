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
        XCTAssertEqual(grid[2, 1], 6)
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
}

extension GridTests {
    func testInitWithContentsWidthHeightDefault() {
        let grid = Grid(from: [[0], [1], [2, 3, 4]], width: 4, height: 4, default: -1)
        let targetGrid = Grid([[0, -1, -1, -1], [1, -1, -1, -1], [2, 3, 4, -1], [-1, -1, -1, -1]])
        XCTAssertEqual(grid, targetGrid)
    }
}

// MARK: Appending and inserting
extension GridTests {
    func testInsertingRowAtTheBeginningIncreaseHeight() {
        grid.insert(row: [7, 8], at: 0)
        XCTAssertEqual(grid.height, 4)
    }

    func testInsertingRowAtTheBeginning() {
        grid.insert(row: [7, 8], at: 0)
        XCTAssertEqual(grid, Grid([[7, 8], [1, 2], [3, 4], [5, 6]]))
    }
    
    func testInsertingRowInTheMiddleIncreaseHeight() {
        grid.insert(row: [7, 8], at: 1)
        XCTAssertEqual(grid.height, 4)
    }
    
    func testInsertingRowInTheMiddle() {
        grid.insert(row: [7, 8], at: 2)
        XCTAssertEqual(grid, Grid([[1, 2], [3, 4], [7, 8], [5, 6]]))
    }
    
    func testAppendRowIncreaseHeight() {
        grid.append(row: [7, 8])
        XCTAssertEqual(grid.height, 4)
    }
    
    func testAppendRow() {
        grid.append(row: [7, 8])
        XCTAssertEqual(grid, Grid([[1, 2], [3, 4], [5, 6], [7, 8]]))
    }
    
    func testInsertingColumnAtTheBeginningIncreaseWidth() {
        grid.insert(column: [7, 8, 9], at: 0)
        XCTAssertEqual(grid.width, 3)
    }
    
    func testInsertingColumnAtTheBeginning() {
        grid.insert(column: [7, 8, 9], at: 0)
        XCTAssertEqual(grid, Grid([[7, 1, 2], [8, 3, 4], [9, 5, 6]]))
    }
    
    func testInsertingColumnInTheMiddleIncreaseHeight() {
        grid.insert(column: [7, 8, 9], at: 1)
        XCTAssertEqual(grid.width, 3)
    }
    
    func testInsertingColumnInTheMiddle() {
        grid.insert(column: [7, 8, 9], at: 1)
        XCTAssertEqual(grid, Grid([[1, 7, 2], [3, 8, 4], [5, 9, 6]]))
    }
    
    func testAppendColumnIncreaseWidth() {
        grid.append(column: [10, 11, 12])
        XCTAssertEqual(grid.width, 3)
    }
    
    func testAppendColumn() {
        grid.append(column: [10, 11, 12])
        XCTAssertEqual(grid, Grid([[1, 2, 10], [3, 4, 11], [5, 6, 12]]))
    }
}
