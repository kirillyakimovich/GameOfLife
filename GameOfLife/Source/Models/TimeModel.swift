//
//  TimeModel.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 1/23/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

protocol TimeModelDelegate: class {
    func tick(_ timeModel: TimeModel)
}

class TimeModel {
    weak var delegate: TimeModelDelegate?
    var tickInterval: TimeInterval = 0.5
    private var timer: Timer?
    var isTicking = false {
        willSet {
            if newValue == isTicking {
                return
            }
        }
        didSet {
            if let timer = timer {
                timer.invalidate()
            }
            if isTicking == true {
                timer = Timer.scheduledTimer(timeInterval: tickInterval, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true);
            }
        }
    }
        
    @objc func tick() {
        delegate?.tick(self)
    }

}
