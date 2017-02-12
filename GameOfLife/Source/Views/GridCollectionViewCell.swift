//
//  CollectionViewCell.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 1/28/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    let gridView: GridView
    override init(frame: CGRect) {
        gridView = GridView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        gridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.init(frame: frame)
        
        contentView.addSubview(gridView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var grid: Grid<CellState>? {
        didSet {
            gridView.datasource = grid
        }
    }
}
