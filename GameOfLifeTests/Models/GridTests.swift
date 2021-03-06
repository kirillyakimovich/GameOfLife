//
//  GridTests.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/3/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import XCTest
@testable import GameOfLife

extension Int: Colorable {
    public func color() -> UIColor {
        return .clear
    }
}

class GridTests: XCTestCase {
    var grid = Grid([[1, 2], [3, 4], [5, 6]])
    
    func testIsEmptyReturnsTrueForEmtpyGrid() {
        XCTAssertTrue(Grid<Int>().isEmpty())
    }
    
    func testIsEmptyReturnsFalseForNonEmtpyGrid() {
        XCTAssertFalse(grid.isEmpty())
    }
    
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
    
    func testNormalCycledSubscript() {
        XCTAssertEqual(grid[cycledRow: 0, cycledColumn: 1], 2)
    }
    
    func testBackwardCycledSubscript() {
        XCTAssertEqual(grid[cycledRow: -1, cycledColumn: -1], 6)
    }
    
    func testForwardCycledSubscript() {
        XCTAssertEqual(grid[cycledRow: 100, cycledColumn: 100], 1)
    }
    
    func testNormalSubscriptWithCycledMode() {
        XCTAssertEqual(grid[2, 0, .cycled], 5)
    }
    
    func testBackwardSubscriptWithCycledMode() {
        XCTAssertEqual(grid[-1, -1, .cycled], 6)
    }
    
    func testForwardSubscriptWithCycledMode() {
        XCTAssertEqual(grid[100, 100, .cycled], 1)
    }
    
    func testNormalSubscriptWithBoundedMode() {
        XCTAssertEqual(grid[1, 1, .bounded], 4)
    }
    
    func testBackwardSubscriptWithBoundedMode() {
        XCTAssertEqual(grid[-1, -1, .bounded], nil)
    }
    
    func testForwardSubscriptWithBoundedMode() {
        XCTAssertEqual(grid[100, 100, .bounded], nil)
    }
    
    func testRectangularSubscriptReturnsEmptyGridIfRowsRangeIsEmpty() {
        let result = grid[rowsBounds:Range(0..<0), columnsBounds:Range(0..<1)]
        XCTAssertTrue(result.isEmpty())
    }

    func testRectangularSubscriptReturnsEmptyGridIfColumnsRangeIsEmpty() {
        let result = grid[rowsBounds:Range(0..<1), columnsBounds:Range(0..<0)]
        XCTAssertTrue(result.isEmpty())
    }
    
    func testRectangularSubscriptReturnsEmptyGridIfBothRangesAreEmpty() {
        let result = grid[rowsBounds:Range(0..<0), columnsBounds:Range(0..<0)]
        XCTAssertTrue(result.isEmpty())
    }
    
    func testRectangularSubscriptReturnsForWidth1Height1() {
        let result = grid[rowsBounds:Range(1..<2), columnsBounds:Range(0..<0)]
        XCTAssertTrue(result.isEmpty())
    }
    

    func testContainsReturnsTrueForPresetnElement() {
        XCTAssertTrue(grid.contains(3))
    }
    
    func testContainsReturnsFalseForAbsentElement() {
        XCTAssertFalse(grid.contains(300))
    }
}

// MARK: Equatable
extension GridTests {
    func testIsEqualToSelf() {
        let grid = Grid(side: 3, repeating: 10)
        XCTAssertEqual(grid, grid)
    }
    
    func testGridsWithDifferentSizesButSameElementsAreNotEqual() {
        let grid1 = Grid(side: 1, repeating: 3)
        let grid2 = Grid(side: 3, repeating: 3)
        
        XCTAssertNotEqual(grid1, grid2)
    }
    
    func testGridsWithSameSizeButDifferentElementsAreNotEqual() {
        let grid1 = Grid(side: 3, repeating: 2)
        let grid2 = Grid(side: 3, repeating: 5)
        
        XCTAssertNotEqual(grid1, grid2)
    }
}

extension GridTests {
    func testInitWithContentsWidthHeightDefault() {
        let grid = Grid(from: [[0], [1], [2, 3, 4]], width: 4, height: 4, default: -1)
        let targetGrid = Grid([[0, -1, -1, -1], [1, -1, -1, -1], [2, 3, 4, -1], [-1, -1, -1, -1]])
        XCTAssertEqual(grid, targetGrid)
    }
    
    func testInitWithContentsWidthHeightDefaultWithBiggerWidth() {
        let grid = Grid(from: [[0], [1], [2, 3, 4]], width: 5, height: 4, default: -1)
        let targetGrid = Grid([[0, -1, -1, -1, -1], [1, -1, -1, -1, -1], [2, 3, 4, -1, -1], [-1, -1, -1, -1, -1]])
        XCTAssertEqual(grid, targetGrid)
    }
    
    func testInitWithContentsWidthHeightDefaultWithBiggerHeight() {
        let grid = Grid(from: [[0], [1], [2, 3, 4]], width: 4, height: 5, default: -1)
        let targetGrid = Grid([[0, -1, -1, -1], [1, -1, -1, -1], [2, 3, 4, -1,], [-1, -1, -1, -1], [-1, -1, -1, -1]])
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

// MARK: Removing
extension GridTests {
    func testRemoveRowFromTheBeginningDecreaseHeight() {
        grid.removeRow(at: 0)
        XCTAssertEqual(grid.height, 2)
    }

    func testRemoveRowFromTheBeginning() {
        grid.removeRow(at: 0)
        XCTAssertEqual(grid, Grid([[3, 4], [5, 6]]))
    }
    
    func testRemoveRowFromTheMiddleDecreaseHeight() {
        grid.removeRow(at: 1)
        XCTAssertEqual(grid.height, 2)
    }
    
    func testRemoveRowFromTheMiddle() {
        grid.removeRow(at: 1)
        XCTAssertEqual(grid, Grid([[1, 2], [5, 6]]))
    }
    
    func testRemoveRowFromTheEndDecreaseHeight() {
        grid.removeRow(at: grid.height - 1)
        XCTAssertEqual(grid.height, 2)
    }
    
    func testRemoveRowFromTheEnd() {
        grid.removeRow(at: grid.height - 1)
        XCTAssertEqual(grid, Grid([[1, 2], [3, 4]]))
    }
    
    func testRemoveLastRowDecreaseHeight() {
        grid.removeLastRow()
        XCTAssertEqual(grid.height, 2)
    }
    
    func testRemoveLastRow() {
        grid.removeLastRow()
        XCTAssertEqual(grid, Grid([[1, 2], [3, 4]]))
    }
    
    func testRemoveColumnFromTheBeginningDecreaseWidth() {
        grid.removeColumn(at: 0)
        XCTAssertEqual(grid.width, 1)
    }
    
    func testRemoveColumnFromTheBeginning() {
        grid.removeColumn(at: 0)
        XCTAssertEqual(grid, Grid([[2], [4], [6]]))
    }
    
    func testRemoveColumnFromTheMiddleDecreaseWidth() {
        grid.removeColumn(at: 1)
        XCTAssertEqual(grid.width, 1)
    }
    
    func testRemoveColumnFromTheMiddle() {
        grid.removeColumn(at: 1)
        XCTAssertEqual(grid, Grid([[1], [3], [5]]))
    }
    
    func testRemoveColumnFromTheEndDecreaseWidth() {
        grid.removeColumn(at: grid.width - 1)
        XCTAssertEqual(grid.width, 1)
    }
    
    func testRemoveColumnFromTheEnd() {
        grid.removeColumn(at: grid.width - 1)
        XCTAssertEqual(grid, Grid([[1], [3], [5]]))
    }
    
    func testRemoveLastColumnDecreaseWidth() {
        grid.removeLastColumn()
        XCTAssertEqual(grid.width, 1)
    }
    
    func testRemoveLastColumn() {
        grid.removeLastColumn()
        XCTAssertEqual(grid, Grid([[1], [3], [5]]))

    }
}

// MARK: Insetting
extension GridTests {
    func testInsetBy0DoesNotModifyGrid() {
        var modifided = grid
        modifided.insetBy(dx: 0, dy: 0, repeating: 0)
        
        XCTAssertEqual(grid, modifided)
    }
    
    func testInsetXBy1YBy1() {
        grid.insetBy(dx: 1, dy: 1, repeating: 0)
        let target: Grid<Int> = Grid()
        XCTAssertEqual(grid,  target)
    }
    
    func testInsetXByMinus1YByMinus1() {
        grid.insetBy(dx: -1, dy: -1, repeating: 0)
        let target = Grid([[0, 0, 0, 0], [0, 1, 2, 0], [0, 3, 4, 0], [0, 5, 6, 0], [0, 0, 0, 0]])
        XCTAssertEqual(grid,  target)
    }
    
    func testInsetXBy1YBy0() {
        grid.insetBy(dx: 1, dy: 0, repeating: 0)
        XCTAssertEqual(grid,  Grid([[3, 4]]))
    }
    
    func testInsetXBy0YBy1() {
        grid.insetBy(dx: 0, dy: 1, repeating: 0)
        XCTAssertEqual(grid,  Grid())
    }

    func testInsetXByMinus1YByZero() {
        grid.insetBy(dx: -1, dy: 0, repeating: 0)
        let target = Grid([[0, 0], [1, 2], [3, 4], [5, 6], [0, 0]])
        XCTAssertEqual(grid,  target)
    }
    
    func testInsetXByZeroYByMinus1() {
        grid.insetBy(dx: 0, dy: -1, repeating: 0)
        let target = Grid([[0, 1, 2, 0], [0, 3, 4, 0], [0, 5, 6, 0]])
        XCTAssertEqual(grid,  target)
    }
}

// MARK: Extraction
extension GridTests {
    func testExtractionFromEmptyIsEmpty() {
        let grid = Grid<CellState>()
        let extracted = grid.extractAlive()
        
        XCTAssertTrue(extracted.isEmpty())
    }
    
    func testExtractionFromFullyAliveIsNotEmpty() {
        let grid = Grid<CellState>([[.alive, .alive], [.alive, .alive]])
        let extracted = grid.extractAlive()
        
        XCTAssertNotNil(extracted)
    }
    
    func testExtractionFromFullyAliveIsEqualToOrigin() {
        let grid = Grid<CellState>([[.alive, .alive], [.alive, .alive]])
        
        let extracted = grid.extractAlive()
        XCTAssertEqual(grid, extracted)
    }
    
    func testExtractedOfSideOne() {
        let grid = Grid<CellState>(from: [[.alive]], width: 3, height: 3, default: .dead)
        let targetGrid: Grid<CellState> = Grid([[.alive]])
        
        let extracted = grid.extractAlive()
        XCTAssertEqual(extracted, Optional(targetGrid))
    }
    
    func testExtractedOfSideTwo() {
        /* d d d
         d a a
         d a a*/
        let grid = Grid<CellState>(from: [[], [.dead, .alive, .alive], [.dead, .alive, .alive]], width: 3, height: 3, default: .dead)
        let targetGrid:Grid<CellState> = Grid(width: 2, height: 2, repeating: .alive)
        
        let extracted = grid.extractAlive()
        XCTAssertEqual(extracted, Optional(targetGrid))
    }
    
    func testAnotherExtractedOfSideTwo() {
        /* a d d
         a d d
         d d d*/
        let grid = Grid<CellState>(from: [[.alive], [.alive], []], width: 3, height: 3, default: .dead)
        let targetGrid:Grid<CellState> = Grid([[.alive], [.alive]])
        
        let extracted = grid.extractAlive()
        XCTAssertEqual(extracted, Optional(targetGrid))
    }
    
    func testAnotherExtractedOfSideThree() {
        /* a a a
         d d d
         d d d*/
        let grid = Grid<CellState>(from: [[.alive, .alive, .alive], [], []], width: 3, height: 3, default: .dead)
        let targetGrid:Grid<CellState> = Grid([[.alive, .alive, .alive]])
        
        let extracted = grid.extractAlive()
        XCTAssertEqual(extracted, Optional(targetGrid))
    }
}

// Mark: Neighborhood
extension GridTests {
    func testNeighborhoodStartingAtNonConformingElementReturnsEmptyGrid() {
        //var grid = Grid([[1, 2], [3, 4], [5, 6]])
        let neighborhood = grid.neighborhoodStarting(atRow: 0, column: 1) {return $0 > 3}
        XCTAssertTrue(neighborhood.isEmpty())
    }
    
    func testNeighborhoodStartingAtOnlyConformingElementReturnsGridOfWidthOne() {
        let neighborhood = grid.neighborhoodStarting(atRow: 0, column: 1) {return $0 == 2}
        XCTAssertTrue(neighborhood.width == 1)
    }
    
    func testNeighborhoodStartingAtOnlyConformingElementReturnsGridOfHeightOne() {
        let neighborhood = grid.neighborhoodStarting(atRow: 0, column: 1) {return $0 == 2}
        XCTAssertTrue(neighborhood.height == 1)
    }
    
    func testNeighborhoodStartingAtOnlyConformingElementReturnsGridWithOnlyThisElement() {
        let neighborhood = grid.neighborhoodStarting(atRow: 0, column: 1) {return $0 == 2}
        XCTAssertEqual(neighborhood, Grid([[2]]))
    }
}

// MARK: Moving element
extension GridTests {
    func testMovingElementByZeroWillNotModifyGrid() {
        let initial = grid
        grid.moveElement(at: 1, 1, by: 0, 0, placeholder: 0)
        XCTAssertEqual(grid, initial)
    }
    
    func testMovingElementToTop() {
        grid.moveElement(at: 1, 0, by: 0, -1, placeholder: 0)
        XCTAssertEqual(grid, Grid([[3, 2], [0, 4], [5, 6]]))
    }
    
    func testMovingElementToBottom() {
        grid.moveElement(at: 0, 0, by: 0, 1, placeholder: 0)
        XCTAssertEqual(grid, Grid([[0, 2], [1, 4], [5, 6]]))
    }
    
    func testMovingElementToTheLeft() {
        grid.moveElement(at: 0, 1, by: -1, 0, placeholder: 0)
        XCTAssertEqual(grid, Grid([[2, 0], [3, 4], [5, 6]]))
    }

    func testMovingElementToTheRight() {
        grid.moveElement(at: 2, 0, by: 1, 0, placeholder: 0)
        XCTAssertEqual(grid, Grid([[1, 2], [3, 4], [0, 5]]))
    }
}


