//
//  ViewController.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/22/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let side = 7
    lazy var gridModel: GridModel = {
        return GridModel(side: self.side)
    }()
    lazy var timeModel: TimeModel = {
        let model = TimeModel()
        model.delegate = self
        return model
    }()
    
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.gridModel = gridModel
        gridModel.delegate = self
        updateView()
    }
    
    @IBOutlet weak var stateButton: UIButton!
    @IBAction func toggle(_ sender: Any) {
        timeModel.isTicking = !timeModel.isTickinggi
        updateView()
    }
    
    @IBOutlet weak var stepButton: UIButton!
    @IBAction func touchOnStep(_ sender: UIButton) {
        gridModel.step()
    }
    
    func updateView() {
        stepButton.isEnabled = !timeModel.isTicking
        var title: String
        if timeModel.isTicking {
            title = "Stop"
        } else {
            title = "Start"
        }
        stateButton.setTitle(title, for: .normal)
    }
}

extension ViewController: GridModelDelegate {
    func gridModelUpdated(_ gridModel: GridModel) {
        if (timeModel.isTicking) {
            timeModel.isTicking = !gridModel.isStuck
        }
        updateView()
        gridView.setNeedsDisplay()
    }
}

extension ViewController: TimeModelDelegate {
    func tick(_ timeModel: TimeModel) {
        gridModel.step()
    }
}
