//
//  GridModel.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/22/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import Foundation

protocol GridModelDelegate: class {
    func gridModelUpdated(_ gridModel: GridModel)
}

class GridModel {
    weak var delegate: GridModelDelegate?
    
    let width: Int
    let height: Int
    fileprivate var grid: Grid<CellState> {
        didSet {
            delegate?.gridModelUpdated(self)
        }
    }
    public fileprivate(set) var isStuck = false
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = Grid(width: width, height: height, repeating: .dead)
    }
    
    convenience init(side: Int) {
        self.init(width: side, height: side)
    }
}

extension GridModel {
    public func toggleAt(x: Int, y: Int) {
        grid[x, y] = grid[x, y].switched()
    }
    
    public func isAliveAt(x: Int, y: Int) -> Bool {
        return grid[x, y] == .alive
    }
    
    public func isDeadAt(x: Int, y: Int) -> Bool {
        return grid[x, y] == .dead
    }
    
    public func isAlive() -> Bool {
        return isAlive(grid: grid)
    }
    
    public func isDead() -> Bool {
        return isDead(grid: grid)
    }
    
    public func step() {
        var nextGrid = grid
        for row in 0..<height {
            for column in 0..<width {
                let cell = grid[row, column]
                let aliveNeighbours = neighBours(x: row, y: column).filter{ $0 == .alive }
                let shouldSwitch = cell.shouldSwitch(aliveNeighbours: aliveNeighbours.count)
                if shouldSwitch {
                    nextGrid[row, column] = nextGrid[row, column].switched()
                }
            }
        }
        
        isStuck = isDead(grid: nextGrid) || (grid == nextGrid)
        grid = nextGrid
    }
}

extension GridModel: Equatable {
    static func ==(lhs: GridModel, rhs: GridModel) -> Bool {
        return lhs.grid == rhs.grid
    }
}

extension GridModel {
    public func neighBours(x: Int, y: Int) -> [CellState] {
        var result = [CellState]()
        for xIndex in (x - 1)...(x + 1) {
            for yIndex in (y - 1)...(y + 1) {
                if xIndex == x && yIndex == y {
                    continue
                }
                
                result.append(grid[cycledRow: xIndex, cycledColumn: yIndex])
            }
        }
        return result
    }
    
    fileprivate func isAlive(grid: Grid<CellState>) -> Bool {
        return grid.contains(.alive)
    }
    
    fileprivate func isDead(grid: Grid<CellState>) -> Bool {
        return !isAlive(grid: grid)
    }
}

extension GridModel {
    func extractSignificantPart() -> GridModel? {
        var minAliveCoordinate = (row: Int.max, column: Int.max)
        var maxAliveCoordinate = (row: -1, column: -1)
        for row in 0..<height {
            for column in 0..<width {
                let cell = grid[row, column]
                if cell == .dead {
                    continue
                }
                
                if row < minAliveCoordinate.row {
                    minAliveCoordinate.row = row
                }
                if row > maxAliveCoordinate.row {
                    maxAliveCoordinate.row = row
                }
                
                if column < minAliveCoordinate.column {
                    minAliveCoordinate.column = column
                }
                if column > maxAliveCoordinate.column {
                    maxAliveCoordinate.column = column
                }
                
            }
        }
        
        if maxAliveCoordinate == (-1, -1) {
            return nil
        }
        
        let newHeight = maxAliveCoordinate.row - minAliveCoordinate.row
        let newWidth = maxAliveCoordinate.column - minAliveCoordinate.column

        let extracted = GridModel(width: newWidth + 1, height: newHeight + 1)
        for column in 0...newWidth {
            for row in 0...newHeight {
                let originalCell = grid[minAliveCoordinate.row + row, minAliveCoordinate.column + column]
                if originalCell == .alive {
                    extracted.toggleAt(x: row, y: column)
                }
            }
        }
        
        return extracted
    }
}

// MARK: CustomStringConvertible
extension GridModel: CustomStringConvertible {
    public var description: String {
        return RLERepresentation()
    }
}
