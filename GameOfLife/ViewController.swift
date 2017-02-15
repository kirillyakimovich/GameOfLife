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
                gridView.datasource = lifeModel
                gridView.didSelecteCellAt = lifeModel.toggleAt(x:y:)
                gridView.moveElement = {(fromRow: Int, fromColumn: Int, toRow: Int, toColumn: Int) in
                    lifeModel.grid.moveElement(from: fromRow, fromColumn, to: toRow, toColumn, placeholder: .dead)
                }
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
        guard let lifeModel = lifeModel else {
            return
        }
        
        let currentHeight = Int(sender.value)
        lifeModel.grid.insetBy(dx: lifeModel.height - currentHeight, dy: 0, repeating: .dead)
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
        if let url = Bundle.main.url(forResource: "gosperglidergun", withExtension: "rle", subdirectory: "Patterns") {
            if let contents = try? String(contentsOf: url) {
                if let grid = Grid(with: contents) {
                    lifeModel = LifeModel(grid: grid)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let grid = Grid(side: 10, repeating: CellState.dead)
        lifeModel = LifeModel(grid: grid)
    }
    
    func updateView() {
        gridView.setNeedsDisplay()
        stepButton.isEnabled = !timeModel.isTicking
        var title: String
        if timeModel.isTicking {
            title = "Stop"
        } else {
            title = "Start"
        }
        stateButton.setTitle(title, for: .normal)
        sizeStepper.value = Double(lifeModel!.grid.height)
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
