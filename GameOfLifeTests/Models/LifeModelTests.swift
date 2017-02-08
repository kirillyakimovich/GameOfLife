//
//  LifeModelTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 1/24/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

extension LifeModel {
    func animate() {
        for column in 0..<width {
            for row in 0..<height {
                if isDeadAt(x: row, y: column) {
                    toggleAt(x: row, y: column)
                }
            }
        }
    }
}

class LifeModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitiallyIsDead() {
        let gm = LifeModel(side: 2)
        let isDead = gm.isDead()
        
        XCTAssertTrue(isDead)
    }
    
    // MARK: Equatable
    func testIsEqualToSelf() {
        let gm = LifeModel(side: 3)
        XCTAssertEqual(gm, gm)
    }
    
    func testGridsWithDifferentSizesAreNotEqual() {
        let gm1 = LifeModel(side: 1)
        let gm2 = LifeModel(side: 3)
        
        XCTAssertNotEqual(gm1, gm2)
    }
    
    func testGridsWithAliveCellsAtDifferentIndiciesAreNotEqual() {
        let gm1 = LifeModel(side: 2)
        gm1.toggleAt(x: 0, y: 0)
        let gm2 = LifeModel(side: 2)
        gm2.toggleAt(x: 1, y: 0)
        
        XCTAssertNotEqual(gm1, gm2)
    }
}
