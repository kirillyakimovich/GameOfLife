//
//  Grid.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/3/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

struct Grid<Element> where Element: Equatable {
    public fileprivate(set) var width: Int // number of columns
    public fileprivate(set) var height: Int // number of rows
    fileprivate var grid: Array<Element>
    
    init(width: Int, height: Int, repeating element: Element) {
        self.width = width
        self.height = height
        
        grid = Array<Element>(repeatElement(element, count: width * height))
    }
    
    init(_ contents: [[Element]]) {
        let rows = contents.count
        let columns = contents[0].count
        
        self.init(width: columns, height: rows, repeating: contents[0][0])
        for (i, row) in contents.enumerated() {
            grid.replaceSubrange((i * columns)..<(i * columns + min(columns, row.count)), with: row)
        }
    }
    
    /// This initializer is needed for cases, when contents is not rectangular or there are some missed rows 
    /// If some row contains more than width values, reminded will be just ignored
    /// - Parameters:
    ///   - contents: array of arrays of elements
    ///   - width: desired width
    ///   - height: desired height
    ///   - element: default value to be used in case when missed from contents
    init(from contents: [[Element]], width: Int, height: Int, default element: Element) {
        let neededWidth = width
        let neededHeight = height
        
        self.init(width: neededWidth, height: neededHeight, repeating: element)
        for (i, row) in contents.enumerated() {
            grid.replaceSubrange((i * neededHeight)..<(i * neededHeight + min(neededHeight, row.count)), with: row)
        }
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            return grid[row * width  + column]
        }
        
        set {
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
            return Array(grid[(row * width)..<((row + 1) * width)])
        }
        
        set {
            assert(newValue.count == width)
            grid.replaceSubrange((row * width)..<((row + 1) * width), with: newValue)
        }
    }
    
    subscript(column column: Int) -> [Element] {
        get {
            var result: [Element] = []
            for i in 0..<height {
                result.append(grid[i * width  + column])
            }
            return result
        }
        
        set {
            assert(newValue.count == height)
            for i in 0..<height {
                grid[i * width  + column] = newValue[i]
            }
        }
    }
    
    func contains(_ element: Element) -> Bool {
        return grid.contains(element)
    }
}

extension Grid: Equatable {
    public static func ==(lhs: Grid<Element>, rhs: Grid<Element>) -> Bool {
        return lhs.grid == rhs.grid
    }
}

// MARK: modifications
extension Grid {
    mutating func append(row: [Element]) {
        assert(row.count == width)
        height += 1
        grid.append(contentsOf: row)
    }
    
    mutating func append(column: [Element]) {
        assert(column.count == height)
        width += 1
        for i in 0..<height {
            grid.insert(column[i], at: i * width)
        }
    }
}
