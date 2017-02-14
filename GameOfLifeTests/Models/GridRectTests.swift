//
//  GridRectTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/13/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GridRectTests: XCTestCase {
    var rect = CGRect(x: 0, y: 0, width: 10, height: 20)
    
    func testXStep10() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertEqual(gr.xStep, 10)
    }
    
    func testXStep1() {
        let gr = GridRect(rect, rows: 1, columns: 10)
        XCTAssertEqual(gr.xStep, 1)
    }
    
    func testYStep20() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertEqual(gr.yStep, 20)
    }
    
    func testYStep4() {
        let gr = GridRect(rect, rows: 5, columns: 10)
        XCTAssertEqual(gr.yStep, 4)
    }
}

// MARK: cell(for)
extension GridRectTests {
    func testCellForNotContainedPointIsNil() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertNil(gr.cell(for: CGPoint(x: 100, y: 100)))
    }
    
    func testCellForContainedPointIsNotNil() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertNotNil(gr.cell(for: CGPoint(x: 5, y: 5)))
    }
    
    func testCellForPointx0y0() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        if let position = gr.cell(for: CGPoint(x: 0, y: 0)) {
            XCTAssert(position == (0, 0))
        } else {
            XCTAssertTrue(false)
        }

    }
    
    func testCellForPointx0y15() {
        let gr = GridRect(rect, rows: 20, columns: 1)
        if let position = gr.cell(for: CGPoint(x: 0, y: 15)) {
            XCTAssert(position == (15, 0))
        } else {
            XCTAssertTrue(false)
        }
        
    }
    
    func testCellForPointx3y10() {
        let gr = GridRect(rect, rows: 10, columns: 5)
        if let position = gr.cell(for: CGPoint(x: 3, y: 10)) {
            XCTAssert(position == (5, 1))
        } else {
            XCTAssertTrue(false)
        }
        
    }
    
    func testCellForPointx7dot5y16dot5() {
        let gr = GridRect(rect, rows: 10, columns: 5)
        if let position = gr.cell(for: CGPoint(x: 7.5, y: 16.5)) {
            XCTAssert(position == (8, 3))
        } else {
            XCTAssertTrue(false)
        }
        
    }
}
