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
    
    func testXStep1() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertEqual(gr.xStep, 10)
    }
    
    func testXStep2() {
        let gr = GridRect(rect, rows: 1, columns: 10)
        XCTAssertEqual(gr.xStep, 1)
    }
    
    func testYStep1() {
        let gr = GridRect(rect, rows: 1, columns: 1)
        XCTAssertEqual(gr.yStep, 20)
    }
    
    func testYStep2() {
        let gr = GridRect(rect, rows: 5, columns: 10)
        XCTAssertEqual(gr.yStep, 4)
    }
}
