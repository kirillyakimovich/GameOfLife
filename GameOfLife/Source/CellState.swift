//
//  CellState.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/5/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

enum CellState: Int {
    case alive
    case dead
    
    func switched() -> CellState {
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
