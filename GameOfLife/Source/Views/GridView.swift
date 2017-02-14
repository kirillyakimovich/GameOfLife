//
//  GridView.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/22/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import UIKit

enum DrawingMode {
    case asIs
    case square // keeping every frame square. useful when width and height are different
}

protocol Colorable {
    func color() -> UIColor
}

extension CellState: Colorable {
    func color() -> UIColor {
        switch self {
        case .dead:
            return .white
        case .alive:
            return .black
        }
    }
}

protocol GridViewDataSource {
    var width: Int { get }
    var height: Int { get }
    func colorableAt(_ x: Int, _ y: Int) -> Colorable
}

class GridView: UIView {
    var gridColor = UIColor.gray
    var aliveColor = UIColor.black
    var deadColor = UIColor.white
    var drawingMode: DrawingMode = .square
    
    var datasource: GridViewDataSource?
    var didSelecteCellAt: ((Int, Int) -> ())?

    fileprivate var activeRect: GridRect
    
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
        activeRect = GridRect(CGRect(x: 0, y: 0, width: frame.width, height: frame.height),
                              rows: 1, columns: 1)
        super.init(frame: frame)
        self.addGestureRecognizer(touchRecognizer)
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let datasource = aDecoder.decodeObject(forKey: "dataSource") as? GridViewDataSource {
            self.datasource = datasource
        }
        activeRect = GridRect(CGRect(x: 0, y: 0, width: 1, height: 1),
                              rows: 1, columns: 1)
        super.init(coder: aDecoder)
        self.addGestureRecognizer(touchRecognizer)
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(datasource, forKey: "dataSource")
    }
    
    func stepLength(spread: CGFloat, dencity: Int) -> CGFloat{
        return spread / CGFloat(dencity)
    }
    
    func drawGrid(_ gridRect: GridRect, in context: CGContext) {
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(1)
        
        for (start, end) in gridRect.horizontalGuides {
            context.move(to: start)
            context.addLine(to: end)
            context.strokePath()
        }
        
        for (start, end) in gridRect.verticalGuides {
            context.move(to: start)
            context.addLine(to: end)
            context.strokePath()
        }
    }
    
    func draw(contents datasource: GridViewDataSource, at rect: GridRect, in context: CGContext) {
        for cell in rect.cells() {
            context.setFillColor(datasource.colorableAt(cell.row, cell.column).color().cgColor)
            context.fill(cell.frame)
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let datasource = datasource else {
            return
        }
        
        var rect = rect
        if drawingMode == .square {
            var xInset: CGFloat = 0
            var yInset: CGFloat = 0
            
            switch (datasource.width, datasource.height) {
            case let (width, height) where width < height :
                let step = stepLength(spread: rect.size.height, dencity: datasource.height)
                xInset = step * CGFloat(height - width) / 2
            case let (width, height) where width > height :
                let step = stepLength(spread: rect.size.width, dencity: datasource.width)
                yInset = step * CGFloat(width - height) / 2
            default: break
            }
            rect = rect.insetBy(dx: xInset, dy: yInset)
        }
        
        activeRect = GridRect(rect, rows: datasource.height, columns: datasource.width)
        draw(contents: datasource, at: activeRect, in: context)
        drawGrid(activeRect, in: context)
    }
}

extension GridView {
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

extension GridView {
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
//        case .ended:
//            if let startCell = startCell {
//                moveElement(from: startCell.row, startCell.column, to: cell!.row, cell!.column, placeholder: .dead)
//                startCell = nil
//            }
            
        default:
            self.movingView?.removeFromSuperview()
            self.movingView = nil
        }
    }
}
