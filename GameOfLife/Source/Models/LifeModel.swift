//
//  LifeModel.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/22/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import Foundation
import UIKit.UIColor

protocol LifeModelDelegate: class {
    func LifeModelUpdated(_ LifeModel: LifeModel)
}

class LifeModel {
    weak var delegate: LifeModelDelegate?
    
    public var grid: Grid<CellState> {
        didSet {
            delegate?.LifeModelUpdated(self)
        }
    }
    public var width: Int {
        return grid.width
    }
    public var height: Int {
        return grid.height
    }
    
    public fileprivate(set) var isStuck = false
    
    init(grid: Grid<CellState>) {
        self.grid = grid
    }
}

extension LifeModel: GridViewDataSource {
    func colorAt(_ x: Int, _ y: Int) -> UIColor {
        return isAliveAt(x: x, y: y) ? .black : .white
    }
}

extension LifeModel {
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

extension LifeModel {
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

extension LifeModel {
    func extractSignificantPart() -> LifeModel {
        let extracted = self.grid.extractSignificantPart{ return $0 == .alive }
        return LifeModel(grid: extracted)
    }
}

// MARK: CustomStringConvertible
extension LifeModel: CustomStringConvertible {
    public var description: String {
        return RLERepresentation()
    }
}
