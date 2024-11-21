//
//  MainView.swift
//  PhotoThreads
//
//  Created by Павел on 21.11.2024.
//

import UIKit

class MainView: UIView {
    
    private let collectionDataSource = CollectionViewDataSource()
    private let constant: CGFloat = 10
    var onSegmentChange: (() -> Void)?
    var onButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .white
    }
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collection.dataSource = collectionDataSource.dataSource
        return collection
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Параллельно", "Последовательно"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        return segmentControl
    }()
    
    @objc func segmentValueChanged() {
        onSegmentChange?()
    }
    
    private lazy var calcButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Начать вычисления"
        config.attributedTitle = AttributedString("Комбинаторика", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]))
        config.baseForegroundColor = .black
        config.background.backgroundColor = .systemGray3
        config.background.cornerRadius = 5
        
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            onButtonTapped?()
        })
        button.setImage(UIImage(systemName: "progress.indicator"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private func setupUI() {
        addSubview(scrollView)
        
        scrollView.addSubview(segmentControl)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(calcButton)
        scrollView.addSubview(progressView)
        scrollView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: constant),
            segmentControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            segmentControl.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: constant),
            collectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            
            calcButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: constant * 2),
            calcButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            calcButton.widthAnchor.constraint(equalToConstant: 200),
            
            progressView.topAnchor.constraint(equalTo: calcButton.bottomAnchor, constant: constant),
            progressView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            textLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: constant),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: constant),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -constant),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -constant)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MainView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 5, height: 200)
    }
}
