//
//  SequenceExtensions.swift
//  GameOfLife
//
//  Created by Yakimovich, Kirill on 2/2/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Equatable {
    func group() -> [[Iterator.Element]] {
        return  self.reduce([]) { accumulator , element in
            guard !accumulator.isEmpty else {
                return [[element]]
            }
            
            var result = accumulator
            var lastSubGroup = accumulator.last!
            if lastSubGroup.last! == element {
                lastSubGroup.append(element)
                result[result.count - 1] = lastSubGroup
            } else {
                result.append([element])
            }
            
            return result
        }
    }
}
