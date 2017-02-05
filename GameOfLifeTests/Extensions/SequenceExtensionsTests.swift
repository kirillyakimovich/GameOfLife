//
//  SequenceExtensionsTests.swift
//  GameOfLife
//
//  Created by Yakimovich, Kirill on 2/2/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

class SequenceExtensionsTests: XCTestCase {
    
    func testGroupingEmptyArrayReturnsEmtpyArray() {
        let input = [Int]()
        let target = [[Int]]()
        let output = input.group()
        
        XCTAssert(output.elementsEqual(target, by: ==))
    }
    
    func testGroupingArrayOfInts() {
        let input = [1,2,2,1,1,1,2,2,2,1]
        let target = [[1],[2,2],[1,1,1],[2,2,2],[1]]
        let output = input.group()
        
        XCTAssert(output.elementsEqual(target, by: ==))
    }
    
    func testGroupingString() {
        let input = "abbcdddeea".characters
        let target = ["a","bb","c","ddd","ee","a"]
        let output = input.group()
        let convertedOutput = output.map { String($0) }
        
        XCTAssert(convertedOutput.elementsEqual(target))
    }
}
