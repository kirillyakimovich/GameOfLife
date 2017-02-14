//
//  GridCell.swift
//  GameOfLife
//
//  Created by Yakimovich, Kirill on 2/14/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import UIKit

struct GridCell {
    let row: Int
    let column: Int
}

extension GridCell: Equatable {
    static func ==(lhs: GridCell, rhs: GridCell) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}
