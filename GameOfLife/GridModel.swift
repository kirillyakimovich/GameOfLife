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
    enum State {
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
    
    let side: Int
    fileprivate var grid: Grid {
        didSet {
            delegate?.gridModelUpdated(self)
        }
    }
    public fileprivate(set) var isStuck = false
    
    init(side: Int) {
        self.side = side
        let sideRow = Row(repeatElement(.dead, count: side))
        self.grid = Grid(repeatElement(sideRow, count: side))
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
        for xIndex in 0..<side {
            for yIndex in 0..<side {
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
        guard lhs.side == rhs.side else {
            return false
        }
        for xIndex in 0..<lhs.side {
            for yIndex in 0..<lhs.side {
                if lhs.grid[xIndex][yIndex] != rhs.grid[xIndex][yIndex] {
                    return false
                }
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
        for xIndex in 0..<side {
            for yIndex in 0..<side {
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
        
        let newSide = max(maxAliveCoordinate.x - minAliveCoordinate.x,
                          maxAliveCoordinate.y - minAliveCoordinate.y) + 1
        let extracted = GridModel(side: newSide)
        for xIndex in 0..<side {
            for yIndex in 0..<side {
                let cell = grid[xIndex][yIndex]
                if cell == .alive {
                    extracted.toggleAt(x: xIndex, y: yIndex)
                }
            }
        }
        
        return extracted
    }
}
