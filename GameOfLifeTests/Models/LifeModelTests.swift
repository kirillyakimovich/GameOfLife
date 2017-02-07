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
    
    // MARK: Extraction
    // TODO: move Extraction tests to GridTests
    func testExtractionFromEmptyIsNil() {
        let gm = LifeModel(side: 2)
        let extracted = gm.extractSignificantPart()
        
        XCTAssertNil(extracted)
    }
    func testExtractionFromFullyAliveIsNotNil() {
        let gm = LifeModel(side: 2)
        gm.animate()
        let extracted = gm.extractSignificantPart()
        
        XCTAssertNotNil(extracted)
    }
    
    func testExtractionFromFullyAliveIsEqualToOrigin() {
        let gm = LifeModel(side: 2)
        gm.animate()
        let extracted = gm.extractSignificantPart()
        XCTAssertEqual(Optional.some(gm), extracted)
    }
    
    func testExtractedOfSideOne() {
        let originGM = LifeModel(side: 3)
        originGM.toggleAt(x: 1, y: 1)
        
        let targetGM = LifeModel(side: 1)
        targetGM.toggleAt(x: 0, y: 0)
        
        let extracted = originGM.extractSignificantPart()
        XCTAssertEqual(extracted, Optional(targetGM))
    }
    
    func testExtractedOfSideTwo() {
        /* d d d
           d a a
           d a a*/
        let originGM = LifeModel(side: 3)
        originGM.toggleAt(x: 1, y: 1)
        originGM.toggleAt(x: 2, y: 2)
        
        let targetGM = LifeModel(side: 2)
        targetGM.toggleAt(x: 0, y: 0)
        targetGM.toggleAt(x: 1, y: 1)
        
        let extracted = originGM.extractSignificantPart()
        XCTAssertEqual(extracted, Optional(targetGM))
    }
    
    func testAnotherExtractedOfSideTwo() {
        /* a d d
           a d d
           d d d*/
        let originGM = LifeModel(side: 3)
        originGM.toggleAt(x: 0, y: 1)
        originGM.toggleAt(x: 0, y: 2)
        
        let targetGM = LifeModel(width: 1, height: 2)
        targetGM.animate()
        
        let extracted = originGM.extractSignificantPart()
        XCTAssertEqual(extracted, Optional(targetGM))
    }
    
    func testAnotherExtractedOfSideThree() {
        /* a a a
           d d d
           d d d*/
        let originGM = LifeModel(side: 3)
        originGM.toggleAt(x: 0, y: 0)
        originGM.toggleAt(x: 1, y: 0)
        originGM.toggleAt(x: 2, y: 0)
        
        let targetGM = LifeModel(width: 3, height: 1)
        targetGM.animate()
        
        let extracted = originGM.extractSignificantPart()
        XCTAssertEqual(extracted, Optional(targetGM))
    }
}
