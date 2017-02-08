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
    
    /// Empty grid
    init() {
        width = 0
        height = 0
        
        grid = Array<Element>()
    }
    
    init(width: Int, height: Int, repeating element: Element) {
        self.width = width
        self.height = height
        
        grid = Array<Element>(repeatElement(element, count: width * height))
    }
    
    init(side: Int, repeating element: Element) {
        self.init(width: side, height: side, repeating: element)
    }
    
    init(_ contents: [[Element]]) {
        let rows = contents.count
        assert(rows > 0)
        let columns = contents[0].count
        assert(columns > 0)
        
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
            grid.replaceSubrange((i * neededWidth)..<(i * neededWidth + min(neededHeight, row.count)), with: row)
        }
    }
    
    func isEmpty() -> Bool {
        return width + height > 0
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

// MARK: Appending and inserting
extension Grid {
    mutating func insert(row: [Element], at index: Int) {
        assert(row.count == width)
        assert(index <= height)
        height += 1
        grid.insert(contentsOf: row, at: index * width)
    }
    
    mutating func append(row: [Element]) {
        insert(row: row, at: height)
    }
    
    mutating func insert(column: [Element], at index: Int) {
        assert(column.count == height)
        assert(index <= width)
        width += 1
        for i in 0..<height {
            grid.insert(column[i], at: i * width + index)
        }
    }
    
    mutating func append(column: [Element]) {
        insert(column: column, at: width)
    }
}

// MARK: Removing
extension Grid {
    mutating func removeRow(at index: Int) {
        assert(index >= 0)
        assert(index < height)
        
        grid.removeSubrange((index * width)..<((index + 1) * width))
        height -= 1
    }
    
    mutating func removeLastRow() {
        grid.removeLast(width)
        height -= 1
    }
    
    mutating func removeColumn(at index: Int) {
        assert(index >= 0)
        assert(index < width)
        
        for i in 0..<height {
            // substracting i is needed as we're actually mutating array, when removing element one by one, so we need to handle offset
            grid.remove(at:i * width + index - i)
        }
        width -= 1
    }
    
    mutating func removeLastColumn() {
        assert(width > 0)
        removeColumn(at: width - 1)
    }
}

// MARK: Insetting
extension Grid {
    mutating func insetBy(dx: Int, dy: Int, repeating element: Element) {
        assert(dx * 2 <= width)
        assert(dy * 2 <= height)
        let repeatingColumn = Array<Element>(repeatElement(element, count: height))
        if (dy < 0) {
            for _ in dy..<0 {
                insert(column: repeatingColumn, at: 0)
                append(column: repeatingColumn)
            }
        } else {
            for _ in 0..<dy {
                removeColumn(at: 0)
                removeLastColumn()
            }
        }
        
        let repeatingRow = Array<Element>(repeatElement(element, count: width))
        if (dx < 0) {
            for _ in dx..<0 {
                insert(row: repeatingRow, at: 0)
                append(row: repeatingRow)
            }
        } else {
            for _ in 0..<dx {
                removeRow(at: 0)
                removeLastRow()
            }
        }
    }
}

// MARK: Extracting
extension Grid {
    typealias ExtractionRule = (Element) -> Bool
    func extractSignificantPart(_ rule: ExtractionRule) -> Grid {
        var minAliveCoordinate = (row: height, column: width)
        var maxAliveCoordinate = (row: -1, column: -1)
        for column in 0..<width {
            for row in 0..<height {
                let element = self[row, column]
                if !rule(element) {
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
            return Grid()
        }
        
        var extracted = [[Element]]()
        for row in (minAliveCoordinate.row)...(maxAliveCoordinate.row) {
            let offset = row * self.width
            let startIndex = offset + minAliveCoordinate.column
            let endIndex = offset + maxAliveCoordinate.column
            let subrow = Array(self.grid[startIndex...endIndex])
            extracted.append(subrow)
        }
        return Grid(extracted)
    }
}

extension Grid where Element == CellState {
    func extractAlive() -> Grid {
        return self.extractSignificantPart { return $0 == .alive }
    }
}
