//
//  ViewController.swift
//  PhotoThreads
//
//  Created by Павел on 21.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var mainView = MainView(frame: .zero)
    private lazy var collectionViewDataSource = CollectionViewDataSource()
    private lazy var mainModel = MainModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupCollectionView()
        updatePhotos()
    }
    
    private func updatePhotos() {
        mainView.onSegmentChange = { [weak self] in
            guard let self else { return }
            let segmentIndex = self.mainView.segmentControl.selectedSegmentIndex
            self.mainModel.EditingPhotos(selectedSegmentIndex: segmentIndex, collectionViewDataSource: self.collectionViewDataSource, mainView: mainView)
        }
    }
    
    private func calculateSomeValue() {
        mainView.onButtonTapped = { [weak self] in
            guard let self else { return }
            Task {
                let value = await self.mainModel.calculate()
                self.mainView.textLabel.text = "\(value)"
            }
        }
    }
    
    private func updateProgressView(currentTask: Int) {
        let progress = Float(currentTask) / Float(20)
        DispatchQueue.main.async {
            self.mainView.progressView.setProgress(progress, animated: true)
        }
    }
    
    private func setupCollectionView() {
        collectionViewDataSource.setupDataSource(collectionView: mainView.collectionView)
    }
}

