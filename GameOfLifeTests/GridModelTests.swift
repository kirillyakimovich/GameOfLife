//
//  GridModelTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 1/24/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

extension GridModel {
    func animate() {
        for xIndex in 0..<side {
            for yIndex in 0..<side {
                if isDeadAt(x: xIndex, y: yIndex) {
                    toggleAt(x: xIndex, y: yIndex)
                }
            }
        }
    }
}

class GridModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitiallyIsDead() {
        let gm = GridModel(side: 2)
        let isDead = gm.isDead()
        
        XCTAssertTrue(isDead)
    }
    
    // MARK: Equatable
    func testIsEqualToSelf() {
        let gm = GridModel(side: 3)
        XCTAssertEqual(gm, gm)
    }
    
    func testGridsWithDifferentSizesAreNotEqual() {
        let gm1 = GridModel(side: 1)
        let gm2 = GridModel(side: 3)
        
        XCTAssertNotEqual(gm1, gm2)
    }
    
    func testGridsWithAliveCellsAtDifferentIndiciesAreNotEqual() {
        let gm1 = GridModel(side: 2)
        gm1.toggleAt(x: 0, y: 0)
        let gm2 = GridModel(side: 2)
        gm2.toggleAt(x: 1, y: 0)
        
        XCTAssertNotEqual(gm1, gm2)
    }
    
    // MARK: Extraction
    func testExtractionFromEmptyIsNil() {
        let gm = GridModel(side: 2)
        let extracted = gm.extractSignificantPart()
        
        XCTAssertNil(extracted)
    }
    
    func testExtractionFromFullyAliveIsNotNil() {
        let gm = GridModel(side: 2)
        gm.animate()
        let extracted = gm.extractSignificantPart()
        
        XCTAssertNotNil(extracted)
    }
    
    func testExtractionFromFullyAliveIsEqualToOrigin() {
        let gm = GridModel(side: 2)
        gm.animate()
        let extracted = gm.extractSignificantPart()
        
        XCTAssertEqual(Optional.some(gm), extracted)
    }
    
}
