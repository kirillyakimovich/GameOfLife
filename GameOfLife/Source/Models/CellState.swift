//
//  CellState.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/5/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

enum CellState: Int {
    case dead
    case alive
    
    func switched() -> CellState {
        switch self {
        case .dead:
            return .alive
        case .alive:
            return .dead
        }
    }
    
    func shouldSwitch(aliveNeighbours: Int) -> Bool {
        switch self {
        case .dead:
            if aliveNeighbours == 3 {
                return true
            }
        case .alive:
            if aliveNeighbours < 2 || aliveNeighbours > 3 {
                return true
            }
        }
        
        return false
    }
}

// b - dead cell
// o	alive cell
extension CellState {
    init(rleTag: String) {
        if rleTag == "o" {
            self = .alive
        } else {
            self = .dead
        }
    }
}
