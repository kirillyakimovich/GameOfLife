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

class GridView: UIView {
    var gridColor = UIColor.gray
    var aliveColor = UIColor.black
    var deadColor = UIColor.white
    
    lazy var touchRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(self.touchAction(_:)) )
    } ()
    fileprivate var activeRect: CGRect = CGRect.zero
    
    var lifeModel: LifeModel?
    var drawingMode: DrawingMode = .square
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(touchRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let model = aDecoder.decodeObject(forKey: "model") as? LifeModel {
            self.lifeModel = model
        }
        super.init(coder: aDecoder)
        self.addGestureRecognizer(touchRecognizer)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(lifeModel, forKey: "model")
    }
    
    func stepLength(spread: CGFloat, dencity: Int) -> CGFloat{
        return spread / CGFloat(dencity)
    }
    
    func drawGrid(for model: LifeModel, at rect: CGRect, in context: CGContext) {
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(1)

        let xOrigin = rect.minX
        let yOrigin = rect.minY
        let xStep = stepLength(spread: rect.size.width, dencity: model.width)
        for lineNumber in 0...model.width {
            let x = xOrigin + CGFloat(lineNumber) * xStep
            let top = CGPoint(x: x, y: yOrigin)
            context.move(to: top)
            let bottom = CGPoint(x: x, y:  rect.maxY)
            context.addLine(to: bottom)
            context.strokePath()
        }
        
        let yStep = stepLength(spread: rect.size.height, dencity: model.height)
        for lineNumber in 0...model.height {
            let y = yOrigin + CGFloat(lineNumber) * yStep
            let left = CGPoint(x: xOrigin, y: y)
            context.move(to: left)
            let right = CGPoint(x:rect.maxX, y: y)
            context.addLine(to: right)
            context.strokePath()
        }
    }
    
    func draw(model: LifeModel, at rect: CGRect, in context: CGContext) {
        let xStep = stepLength(spread: rect.size.width, dencity: model.width)
        let yStep = stepLength(spread: rect.size.height, dencity: model.height)
        for row in 0..<model.height {
            for column in 0..<model.width {
                let cellRect = CGRect(x: rect.minX + CGFloat(column) * xStep,
                                      y: rect.minY + CGFloat(row) * yStep,
                                      width: xStep,
                                      height: yStep)
                if lifeModel!.isAliveAt(x: row, y: column) {
                    context.setFillColor(aliveColor.cgColor)
                } else {
                    context.setFillColor(deadColor.cgColor)
                }
                context.fill(cellRect)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let model = lifeModel else {
            return
        }
        
        var rect = rect
        if drawingMode == .square {
            var xInset: CGFloat = 0
            var yInset: CGFloat = 0
            
            switch (model.width, model.height) {
            case let (width, height) where width < height :
                let step = stepLength(spread: rect.size.height, dencity: lifeModel!.height)
                xInset = step * CGFloat(height - width) / 2
            case let (width, height) where width > height :
                let step = stepLength(spread: rect.size.width, dencity: lifeModel!.width)
                yInset = step * CGFloat(width - height) / 2
            default: break
            }
            rect = rect.insetBy(dx: xInset, dy: yInset)
        }
        
        activeRect = rect
        draw(model: model, at: rect, in: context)
        drawGrid(for: model, at: rect, in: context)
    }
}

extension GridView {
    func touchAction(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: self)
        guard activeRect.contains(location) else {
            return
        }
        let xStep = stepLength(spread: activeRect.size.width, dencity: lifeModel!.width)
        let yStep = stepLength(spread: activeRect.size.height, dencity: lifeModel!.height)

        let column = ((location.x - activeRect.minX) / (xStep)).rounded(.towardZero)
        let row = ((location.y - activeRect.minY) / (yStep)).rounded(.towardZero)
        lifeModel!.toggleAt(x: Int(row), y: Int(column))
        setNeedsDisplay()
    }
}
