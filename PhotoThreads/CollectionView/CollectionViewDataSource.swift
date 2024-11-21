//
//  CollectionViewDataSource.swift
//  PhotoThreads
//
//  Created by Павел on 21.11.2024.
//

import Foundation
import UIKit

enum Sections {
    case main
}

class CollectionViewDataSource: NSObject {
    
    private lazy var mainModel = MainModel()
    var dataSource: UICollectionViewDiffableDataSource<Sections, UIImage>?
    
    func setupDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath)
            as! CollectionViewCell
            cell.configure(with: image)
            return cell
        })
        updateDataSource(with: mainModel.images)
    }
    
    func updateDataSource(with images: [UIImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
