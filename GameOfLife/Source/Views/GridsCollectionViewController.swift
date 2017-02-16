//
//  GridsCollectionViewController.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/11/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GridCollectionViewCell"

class GridsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        if let url = Bundle.main.url(forResource: "gosperglidergun", withExtension: "rle", subdirectory: "Patterns") {
            if let contents = try? String(contentsOf: url) {
                cell.grid = Grid(with: contents)
            }
        }
        
        return cell
    }
}
