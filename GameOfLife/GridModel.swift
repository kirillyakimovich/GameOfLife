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
    enum State: Int {
        case alive
        case dead
        
        func switched() -> State {
            switch self {
            case .alive:
                return .dead
            case .dead:
                return .alive
            }
        }
        
        func shouldSwitch(aliveNeighbours: Int) -> Bool {
            switch self {
            case .alive:
                if aliveNeighbours < 2 || aliveNeighbours > 3 {
                    return true
                }
            case .dead:
                if aliveNeighbours == 3 {
                    return true
                }
            }
            
            return false
        }
    }
    
    typealias Row = [State]
    typealias Grid = [Row]
    
    weak var delegate: GridModelDelegate?
    
    let width: Int
    let height: Int
    fileprivate var grid: Grid {
        didSet {
            delegate?.gridModelUpdated(self)
        }
    }
    public fileprivate(set) var isStuck = false
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        let sideRow = Row(repeatElement(.dead, count: height))
        self.grid = Grid(repeatElement(sideRow, count: width))
    }
    
    convenience init(side: Int) {
        self.init(width: side, height: side)
    }
}

extension GridModel {
    public func toggleAt(x: Int, y: Int) {
        grid[x][y] = grid[x][y].switched()
    }
    
    public func isAliveAt(x: Int, y: Int) -> Bool {
        return grid[x][y] == .alive
    }
    
    public func isDeadAt(x: Int, y: Int) -> Bool {
        return grid[x][y] == .dead
    }
    
    public func isAlive() -> Bool {
        return isAlive(grid: grid)
    }
    
    public func isDead() -> Bool {
        return isDead(grid: grid)
    }
    
    public func step() {
        var nextGrid = grid
        for xIndex in 0..<width {
            for yIndex in 0..<height {
                let cell = grid[xIndex][yIndex]
                let aliveNeighbours = neighBours(x: xIndex, y: yIndex).filter{ $0 == .alive }
                let shouldSwitch = cell.shouldSwitch(aliveNeighbours: aliveNeighbours.count)
                if shouldSwitch {
                    nextGrid[xIndex][yIndex] = nextGrid[xIndex][yIndex].switched()
                }
            }
        }
        
        isStuck = isDead(grid: nextGrid) || grid.elementsEqual(nextGrid, by: ==)
        grid = nextGrid
    }
}

extension GridModel: Equatable {
    static func ==(lhs: GridModel, rhs: GridModel) -> Bool {
        guard lhs.width == rhs.width, lhs.height == rhs.height else {
            return false
        }
        for xIndex in 0..<lhs.width {
            if lhs.grid[xIndex] != rhs.grid[xIndex] {
                return false
            }
        }
        return true
    }
}

extension GridModel {
    public func neighBours(x: Int, y: Int) -> [State] {
        var result = [State]()
        for xIndex in (x - 1)...(x + 1) {
            for yIndex in (y - 1)...(y + 1) {
                if xIndex == x && yIndex == y {
                    continue
                }
                
                result.append(grid[cycled: xIndex][cycled: yIndex])
            }
        }
        return result
    }
    
    fileprivate func isAlive(grid: Grid) -> Bool {
        return !grid.flatMap { $0.filter {$0 == .alive }}.isEmpty
    }
    
    fileprivate func isDead(grid: Grid) -> Bool {
        return !isAlive(grid: grid)
    }
}

extension GridModel {
    func extractSignificantPart() -> GridModel? {
        var minAliveCoordinate = (x: Int.max, y: Int.max)
        var maxAliveCoordinate = (x: -1, y: -1)
        for xIndex in 0..<width {
            for yIndex in 0..<height {
                let cell = grid[xIndex][yIndex]
                if cell == .dead {
                    continue
                }
                
                if xIndex < minAliveCoordinate.x {
                    minAliveCoordinate.x = xIndex
                }
                if xIndex > maxAliveCoordinate.x {
                    maxAliveCoordinate.x = xIndex
                }
                
                if yIndex < minAliveCoordinate.y {
                    minAliveCoordinate.y = yIndex
                }
                if yIndex > maxAliveCoordinate.y {
                    maxAliveCoordinate.y = yIndex
                }
                
            }
        }
        
        if maxAliveCoordinate == (-1, -1) {
            return nil
        }
        
        let newWidth = maxAliveCoordinate.x - minAliveCoordinate.x
        let newHeight = maxAliveCoordinate.y - minAliveCoordinate.y
        let extracted = GridModel(width: newWidth + 1, height: newHeight + 1)
        for xIndex in 0...newWidth {
            for yIndex in 0...newHeight {
                let originalCell = grid[minAliveCoordinate.x + xIndex][minAliveCoordinate.y + yIndex]
                if originalCell == .alive {
                    extracted.toggleAt(x: xIndex, y: yIndex)
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
