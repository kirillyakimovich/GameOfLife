//
//  GridRect.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/13/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import UIKit

typealias GridCell = (row: Int, column: Int)

struct GridRect {
    let rect: CGRect
    let rows: Int
    let columns: Int
    
    init(_ rect: CGRect, rows: Int, columns: Int) {
        assert(!rect.isEmpty)
        assert(rows > 0)
        assert(columns > 0)
        
        self.rect = rect
        self.rows = rows
        self.columns = columns
    }
    
    private func stepLength(spread: CGFloat, dencity: Int) -> CGFloat{
        return spread / CGFloat(dencity)
    }
    
    public var xStep: CGFloat {
        return stepLength(spread: rect.width, dencity: columns)
    }
    
    public var yStep: CGFloat {
        return stepLength(spread: rect.height, dencity: rows)
    }
    
    public func cell(for point: CGPoint) -> GridCell? {
        guard rect.contains(point) else {
            return nil
        }
        
        let column = Int(((point.x - rect.minX) / (xStep)).rounded(.towardZero))
        let row = Int(((point.y - rect.minY) / (yStep)).rounded(.towardZero))

        return (row, column)
    }
}
