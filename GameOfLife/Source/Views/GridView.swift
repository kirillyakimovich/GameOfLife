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
    
    var datasource: GridViewDataSource?
    var didSelecteCellAt: ((Int, Int) -> ())?

    fileprivate var activeRect: GridRect
    
    var drawingMode: DrawingMode = .square
    
    lazy var touchRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(self.touchAction(_:)) )
    } ()
    
    override init(frame: CGRect) {
        activeRect = GridRect(CGRect(x: 0, y: 0, width: frame.width, height: frame.height),
                              rows: 1, columns: 1)
        super.init(frame: frame)
        self.addGestureRecognizer(touchRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let datasource = aDecoder.decodeObject(forKey: "dataSource") as? GridViewDataSource {
            self.datasource = datasource
        }
        activeRect = GridRect(CGRect(x: 0, y: 0, width: 1, height: 1),
                              rows: 1, columns: 1)
        super.init(coder: aDecoder)
        self.addGestureRecognizer(touchRecognizer)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(datasource, forKey: "dataSource")
    }
    
    func stepLength(spread: CGFloat, dencity: Int) -> CGFloat{
        return spread / CGFloat(dencity)
    }
    
    func draw(_ datasource: GridViewDataSource, at rect: CGRect, in context: CGContext) {
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(1)
        
        let xOrigin = rect.minX
        let yOrigin = rect.minY
        let xStep = stepLength(spread: rect.size.width, dencity: datasource.width)
        for lineNumber in 0...datasource.width {
            let x = xOrigin + CGFloat(lineNumber) * xStep
            let top = CGPoint(x: x, y: yOrigin)
            context.move(to: top)
            let bottom = CGPoint(x: x, y:  rect.maxY)
            context.addLine(to: bottom)
            context.strokePath()
        }
        
        let yStep = stepLength(spread: rect.size.height, dencity: datasource.height)
        for lineNumber in 0...datasource.height {
            let y = yOrigin + CGFloat(lineNumber) * yStep
            let left = CGPoint(x: xOrigin, y: y)
            context.move(to: left)
            let right = CGPoint(x:rect.maxX, y: y)
            context.addLine(to: right)
            context.strokePath()
        }
    }
    
    func draw(contents datasource: GridViewDataSource, at rect: CGRect, in context: CGContext) {
        let xStep = stepLength(spread: rect.size.width, dencity: datasource.width)
        let yStep = stepLength(spread: rect.size.height, dencity: datasource.height)
        for row in 0..<datasource.height {
            for column in 0..<datasource.width {
                context.setFillColor(datasource.colorableAt(row, column).color().cgColor)
                let cellRect = CGRect(x: rect.minX + CGFloat(column) * xStep,
                                      y: rect.minY + CGFloat(row) * yStep,
                                      width: xStep,
                                      height: yStep)
                context.fill(cellRect)
            }
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
        draw(contents: datasource, at: rect, in: context)
        draw(datasource, at: rect, in: context)
    }
}

extension GridView {
    func touchAction(_ sender:UITapGestureRecognizer) {
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
