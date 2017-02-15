//
//  LooseGridView.swift
//  GameOfLife
//
//  Created by Yakimovich, Kirill on 2/15/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import UIKit

class LooseGridView: GridView {
    var didSelecteCellAt: ((Int, Int) -> ())?
    var moveElement: ((Int, Int, Int, Int) -> Void)?

    // lazyness is needed to allow selectors to be defined in extensions
    lazy var touchRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(self.touchAction(_:)))
    } ()
    
    lazy var longPressRecognizer: UILongPressGestureRecognizer = {
        UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(_:)))
    }()
    
    fileprivate var startCell: GridCell?
    fileprivate var movingView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(touchRecognizer)
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(touchRecognizer)
        self.addGestureRecognizer(longPressRecognizer)
    }
}

extension LooseGridView {
    func touchAction(_ sender: UITapGestureRecognizer) {
        guard let didSelecteCellAt = didSelecteCellAt else {
            return
        }
        
        let location = sender.location(in: self)
        guard let cell = activeRect.cell(for: location) else {
            return
        }
        
        didSelecteCellAt(cell.row, cell.column)
    }
}

extension LooseGridView {
    func longPressAction(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self)
        let cell = activeRect.cell(for: location)
        if cell == nil {
            sender.isEnabled = false
            sender.isEnabled = true
        } else if self.movingView == nil {
            self.movingView = UIView(frame: cell!.frame)
            self.movingView?.backgroundColor = UIColor.red
            self.addSubview(self.movingView!)
        }
        
        switch sender.state {
        case .began:
            startCell = cell
            fallthrough
        case .changed:
            self.movingView?.frame = cell!.frame
        case .ended:
            if let startCell = startCell {
                moveElement?(startCell.row, startCell.column, cell!.row, cell!.column)
            }
            fallthrough
        default:
            startCell = nil
            movingView?.removeFromSuperview()
            movingView = nil
        }
    }
}
