//
//  Grid.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/3/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

struct Grid<Element> where Element: Equatable {
    public private(set) var width: Int // number of columns
    public private(set) var height: Int // number of rows
    fileprivate var grid: Array<Element>
    
    init(width: Int, height: Int, repeating element: Element) {
        self.width = width
        self.height = height
        
        grid = Array<Element>(repeatElement(element, count: width * height))
    }
    
    init(_ contents: [[Element]]) {
        let x = contents.count
        let y = contents[0].count
        
        self.init(width: x, height: y, repeating: contents[0][0])
        for (i, row) in contents.enumerated() {
            grid.replaceSubrange((i * y)..<(i * y + min(y, row.count)), with: row)
        }
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            print("get (\(width),\(height)) row: \(row), column: \(column), origin: \(row * width  + column), value: \(grid[row * width  + column])")
            return grid[row * width  + column]
        }
        
        set {
            print("set row: \(row), column: \(column), origin: \(row * width  + column), newValue: \(newValue)")
            grid[row * width + column] = newValue
        }
    }
    
    subscript (cycledRow row: Int, cycledColumn column: Int) -> Element {
        var safeRow = row
        if row >= height {
            safeRow = 0
        } else if row < 0 {
            safeRow = height - 1
        }
        
        var safeColumn = column
        if column >= width {
            safeColumn = 0
        } else if column < 0 {
            safeColumn = width - 1
        }
        
        return self[safeRow, safeColumn]
    }
    
    subscript(row row: Int) -> [Element] {
        get {
            return Array(grid[(row * height)..<((row + 1) * height)])
        }
        
        set {
            grid.replaceSubrange((row * height)..<((row + 1) * height), with: newValue)
        }
    }
    
    subscript(column column: Int) -> [Element] {
        get {
            var result: [Element] = []
            for i in 0...height {
                result.append(grid[i * height  + column])
            }
            return result
        }
        
        set {
            assert(newValue.count == width)
            for i in 0...height {
                grid[i * height  + column] = newValue[i]
            }
        }
    }
    
    func flatten() -> [Element] {
        return Array(grid)
    }
}

extension Grid: Equatable {
    public static func ==(lhs: Grid<Element>, rhs: Grid<Element>) -> Bool {
        return lhs.grid == rhs.grid
    }
}
