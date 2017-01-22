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
        
        func toggled() -> State {
            switch self {
            case .alive:
                return .dead
            case .dead:
                return .alive
            }
        }
    }
    typealias Row = [State]
    typealias Grid = [Row]
    
    weak var delegate: GridModelDelegate?
    
    public private(set) var isEvolving = false
    
    let side: Int
    var grid: Grid {
        didSet {
            delegate?.gridModelUpdated(self)
        }
    }
    
    init(side: Int) {
        self.side = side
        let sideRow = Row(repeatElement(.dead, count: side))
        self.grid = Grid(repeatElement(sideRow, count: side))
    }
    
    var timer: Timer?
    func stopEvolving() {
        if let timer = timer {
            timer.invalidate()
        }
        isEvolving = false
    }
    func startEvolving() {
        if let timer = timer {
            timer.invalidate()
        }
        tick()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true);
        isEvolving = true
    }
    
    public func toggleEvolution() {
        if isEvolving  {
            stopEvolving()
        } else {
            startEvolving()
        }
        delegate?.gridModelUpdated(self)
    }
    
    @objc func tick() {
        step()
    }
}

extension GridModel {
    public func toggleAt(x: Int, y: Int) {
        grid[x][y] = grid[x][y].toggled()
    }
    
    public func isAliveAt(x: Int, y: Int) -> Bool {
        return grid[x][y] == .alive
    }
    
    public func isDeadAt(x: Int, y: Int) -> Bool {
        return grid[x][y] == .dead
    }
    
    public func step() {
        var nextGrid = grid
        for xIndex in 0..<side {
            for yIndex in 0..<side {
                let cell = grid[xIndex][yIndex]
                let aliveNeighbours = neighBours(x: xIndex, y: yIndex).filter{ $0 == .alive }
                var requireToggle = false
                switch cell {
                case .alive:
                    if aliveNeighbours.count < 2 || aliveNeighbours.count > 3 {
                        requireToggle = true
                    }
                case .dead:
                    if aliveNeighbours.count == 3 {
                        requireToggle = true
                    }
                }
                if requireToggle {
                    nextGrid[xIndex][yIndex] = nextGrid[xIndex][yIndex].toggled()
                }
            }
        }
        if isEvolving {
            if isDead(grid: nextGrid) || grid.elementsEqual(nextGrid, by: ==) {
                stopEvolving()
            }
        }
        grid = nextGrid
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
    
    func isAlive(grid: Grid) -> Bool {
        return !grid.flatMap { $0.filter {$0 == .alive }}.isEmpty
    }
    
    func isDead(grid: Grid) -> Bool {
        return !isAlive(grid: grid)
    }
}

