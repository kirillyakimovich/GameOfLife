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
    
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.gridModel = gridModel
        gridModel.delegate = self
        updateView()
    }
    
    @IBOutlet weak var stateButton: UIButton!
    @IBAction func toggle(_ sender: Any) {
        gridModel.toggleEvolution()
    }
    
    @IBOutlet weak var stepButton: UIButton!
    @IBAction func touchOnStep(_ sender: UIButton) {
        gridModel.step()
    }
    
    func updateView() {
        stepButton.isEnabled = !gridModel.isEvolving
        var title: String
        if gridModel.isEvolving {
            title = "Stop"
        } else {
            title = "Start"
        }
        stateButton.setTitle(title, for: .normal)
    }
}

extension ViewController: GridModelDelegate {
    func gridModelUpdated(_ gridModel: GridModel) {
        updateView()
        gridView.setNeedsDisplay()
    }
}
