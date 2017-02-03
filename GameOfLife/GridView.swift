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
    
    var xStep: CGFloat {
        return bounds.width / CGFloat(gridModel!.width)
    }
    
    var yStep: CGFloat {
        return bounds.height / CGFloat(gridModel!.height)
    }
    
    override func draw(_ rect: CGRect) {
        let width = gridModel!.width
        let height = gridModel!.height
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1)
    
        for x in 0..<width {
            for y in 0..<height {
                let cellRect = CGRect(x: CGFloat(x) * xStep, y: CGFloat(y) * yStep, width: xStep, height: yStep)
                if gridModel!.isAliveAt(x: x, y: y) {
                    context?.setFillColor(aliveColor.cgColor)
                } else {
                    context?.setFillColor(deadColor.cgColor)
                }
                context?.fill(cellRect)
            }
        }
        
        context?.setStrokeColor(gridColor.cgColor)
        for lineNumber in 0...width {
            let x = CGFloat(lineNumber) * xStep
            let top = CGPoint(x: x, y: 0)
            context?.move(to: top)
            let bottom = CGPoint(x: x, y: rect.height)
            context?.addLine(to: bottom)
            context?.strokePath()
        }
        
        for lineNumber in 0...height {
            let y = CGFloat(lineNumber) * yStep
            let left = CGPoint(x: 0, y: y)
            context?.move(to: left)
            let right = CGPoint(x:rect.width, y: y)
            context?.addLine(to: right)
            context?.strokePath()
        }
    }
}

extension GridView {
    func touchAction(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let xIndex = (location.x / (xStep)).rounded(.towardZero)
        let yIndex = (location.y / (yStep)).rounded(.towardZero)
        gridModel!.toggleAt(x: Int(xIndex), y: Int(yIndex))
        setNeedsDisplay()
    }
}
