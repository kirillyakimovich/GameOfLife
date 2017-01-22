//
//  Extension.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/28/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (cycled index: Index) -> Generator.Element {
        guard count > 0 else {
            fatalError()
        }
        
        var checkedIndex = index
        if index >= endIndex {
            checkedIndex = startIndex
        } else if index < startIndex {
            checkedIndex = self.index(endIndex, offsetBy: -1)
        }
        
        return self[checkedIndex]
    }
}
