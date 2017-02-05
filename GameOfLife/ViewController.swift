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
    var gridModel: GridModel? {
        didSet {
            if let gridModel = gridModel {
                gridModel.delegate = self
                gridView.gridModel = gridModel
                gridView.setNeedsDisplay()
                updateView()
            }
        }
    }
    lazy var timeModel: TimeModel = {
        let model = TimeModel()
        model.delegate = self
        return model
    }()
    
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridModel = GridModel(width: side, height: side + 3)
    }
    
    @IBOutlet weak var stateButton: UIButton!
    @IBAction func toggle(_ sender: Any) {
        timeModel.isTicking = !timeModel.isTicking
        updateView()
    }
    
    @IBOutlet weak var stepButton: UIButton!
    @IBAction func touchOnStep(_ sender: UIButton) {
        gridModel?.step()
    }
    
    @IBAction func touchOnSave(_ sender: UIButton) {
    }
    
    @IBAction func tapOnLoad(_ sender: UIButton) {
        if let url = Bundle.main.url(forResource: "1beacon", withExtension: "rle", subdirectory: "Patterns") {
            if let contents = try? String(contentsOf: url) {
                gridModel = GridModel(with: contents)
            }
        }
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
        if (timeModel.isTicking && gridModel.isStuck) {
            timeModel.isTicking = false
        }
        updateView()
        gridView.setNeedsDisplay()
    }
}

extension ViewController: TimeModelDelegate {
    func tick(_ timeModel: TimeModel) {
        gridModel?.step()
    }
}
