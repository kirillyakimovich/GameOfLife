//
//  GridView.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/22/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import UIKit

class GridView: UIView {
    var gridColor = UIColor.gray
    var aliveColor = UIColor.black
    var deadColor = UIColor.white
    
    lazy var touchRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(self.touchAction(_:)) )
    } ()
    fileprivate var activeRect: CGRect = CGRect.zero
    
    var gridModel: GridModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(touchRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let model = aDecoder.decodeObject(forKey: "model") as? GridModel {
            self.gridModel = model
        }
        super.init(coder: aDecoder)
        self.addGestureRecognizer(touchRecognizer)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(gridModel, forKey: "model")
    }
    
    func stepLength(spread: CGFloat, dencity: Int) -> CGFloat{
        return spread / CGFloat(dencity)
    }
    
    func drawGrid(for model: GridModel, at rect: CGRect, in context: CGContext) {
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
    
    func draw(model: GridModel, at rect: CGRect, in context: CGContext) {
        let xStep = stepLength(spread: rect.size.width, dencity: model.width)
        let yStep = stepLength(spread: rect.size.height, dencity: model.height)
        for x in 0..<model.width {
            for y in 0..<model.height {
                let cellRect = CGRect(x: rect.minX + CGFloat(x) * xStep,
                                      y: rect.minY + CGFloat(y) * yStep,
                                      width: xStep,
                                      height: yStep)
                if gridModel!.isAliveAt(x: x, y: y) {
                    context.setFillColor(aliveColor.cgColor)
                } else {
                    context.setFillColor(deadColor.cgColor)
                }
                context.fill(cellRect)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let rect = rect.insetBy(dx: 50, dy: 50)
        
        activeRect = rect
        draw(model: gridModel!, at: rect, in: context)
        drawGrid(for: gridModel!, at: rect, in: context)
    }
}

extension GridView {
    func touchAction(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: self)
        guard activeRect.contains(location) else {
            return
        }
        let xStep = stepLength(spread: activeRect.size.width, dencity: gridModel!.width)
        let yStep = stepLength(spread: activeRect.size.height, dencity: gridModel!.height)

        let xIndex = ((location.x - activeRect.minX) / (xStep)).rounded(.towardZero)
        let yIndex = ((location.y - activeRect.minY) / (yStep)).rounded(.towardZero)
        gridModel!.toggleAt(x: Int(xIndex), y: Int(yIndex))
        setNeedsDisplay()
    }
}
