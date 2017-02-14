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
        XCTAssertEqual(gr.cell(for: CGPoint(x: 0, y: 0)), GridCell(row: 0, column: 0))
    }
    
    func testCellForPointx0y15() {
        let gr = GridRect(rect, rows: 20, columns: 1)
        XCTAssertEqual(gr.cell(for: CGPoint(x: 0, y: 15)), GridCell(row: 15, column: 0))
    }
    
    func testCellForPointx3y10() {
        let gr = GridRect(rect, rows: 10, columns: 5)
        XCTAssertEqual(gr.cell(for: CGPoint(x: 3, y: 10)), GridCell(row: 5, column: 1))
    }
    
    func testCellForPointx7dot5y16dot5() {
        let gr = GridRect(rect, rows: 10, columns: 5)
        XCTAssertEqual(gr.cell(for: CGPoint(x: 7.5, y: 16.5)), GridCell(row: 8, column: 3))
    }
}

// MARK: guides
extension GridRectTests {
//    var rect = CGRect(x: 0, y: 0, width: 10, height: 20)
    func testHorizontalGuidesCount1() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertEqual(gr.horizontalGuides.count, 2)
    }
    
    func testHorizontalGuides1() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        let first = (CGPoint(x: 0, y:0), CGPoint(x: 10, y: 0))
        let second = (start: CGPoint(x: 0, y:20), end: CGPoint(x: 10, y: 20))
        XCTAssert(gr.horizontalGuides[0] == first)
        XCTAssert(gr.horizontalGuides[1] == second)
    }
    
    func testHorizontalGuidesCount2() {
        let gr = GridRect(rect, rows: 2, columns: 1)
        XCTAssertEqual(gr.horizontalGuides.count, 3)
    }
    
    func testHorizontalGuides2() {
        let gr = GridRect(rect, rows: 2, columns: 1)
        XCTAssertEqual(gr.horizontalGuides.count, 3)
        let first = (CGPoint(x: 0, y:0), CGPoint(x: 10, y: 0))
        let second = (start: CGPoint(x: 0, y:10), end: CGPoint(x: 10, y: 10))
        let third = (start: CGPoint(x: 0, y:20), end: CGPoint(x: 10, y: 20))
        XCTAssert(gr.horizontalGuides[0] == first)
        XCTAssert(gr.horizontalGuides[1] == second)
        XCTAssert(gr.horizontalGuides[2] == third)
    }
    
    func testVerticalGuidesCount1() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertEqual(gr.verticalGuides.count, 2)
    }
    
    func testVerticalGuides1() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        let first = (CGPoint(x: 0, y:0), CGPoint(x: 0, y: 20))
        let second = (start: CGPoint(x: 10, y:0), end: CGPoint(x: 10, y: 20))
        XCTAssert(gr.verticalGuides[0] == first)
        XCTAssert(gr.verticalGuides[1] == second)
    }
}
