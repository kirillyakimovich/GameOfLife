//
//  ViewController.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 11/22/16.
//  Copyright © 2016 Kirill Yakimovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    let side = 7
    var gridModel = GridModel(side: 7)
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
        timeModel.isTicking = !timeModel.isTicking
        updateView()
    }
    
    @IBOutlet weak var stepButton: UIButton!
    @IBAction func touchOnStep(_ sender: UIButton) {
        gridModel.step()
    }
    
    @IBAction func touchOnSave(_ sender: UIButton) {
        if let extracted = gridModel.extractSignificantPart() {
            let data = NSKeyedArchiver.archivedData(withRootObject: extracted)
            UserDefaults.standard.set(data, forKey: "myKey")
        }
    }
    
    @IBAction func tapOnLoad(_ sender: UIButton) {
        if let data = UserDefaults.standard.data(forKey: "myKey") {
            if let model = NSKeyedUnarchiver.unarchiveObject(with: data) as? GridModel {
                gridModel = model
                gridModel.delegate = self
                gridView.gridModel = model
                gridView.setNeedsDisplay()
                updateView()
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
