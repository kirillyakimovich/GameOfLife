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
    var lifeModel: LifeModel? {
        didSet {
            if let lifeModel = lifeModel {
                lifeModel.delegate = self
                gridView.lifeModel = lifeModel
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
    
    @IBOutlet weak var sizeStepper: UIStepper!
    @IBAction func onSizeChange(_ sender: UIStepper) {
    }
    
    
    @IBOutlet weak var stateButton: UIButton!
    @IBAction func toggle(_ sender: Any) {
        timeModel.isTicking = !timeModel.isTicking
        updateView()
    }
    
    @IBOutlet weak var stepButton: UIButton!
    @IBAction func touchOnStep(_ sender: UIButton) {
        lifeModel?.step()
    }
    
    @IBAction func touchOnSave(_ sender: UIButton) {
    }
    
    @IBAction func tapOnLoad(_ sender: UIButton) {
        if let url = Bundle.main.url(forResource: "1beacon", withExtension: "rle", subdirectory: "Patterns") {
            if let contents = try? String(contentsOf: url) {
                lifeModel = LifeModel(with: contents)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifeModel = LifeModel(width: side, height: side + 3)
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

extension ViewController: LifeModelDelegate {
    func LifeModelUpdated(_ lifeModel: LifeModel) {
        if (timeModel.isTicking && lifeModel.isStuck) {
            timeModel.isTicking = false
        }
        updateView()
        gridView.setNeedsDisplay()
    }
}

extension ViewController: TimeModelDelegate {
    func tick(_ timeModel: TimeModel) {
        lifeModel?.step()
    }
}
