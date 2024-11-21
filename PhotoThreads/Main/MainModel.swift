//
//  MainModel.swift
//  PhotoThreads
//
//  Created by Павел on 21.11.2024.
//

import Foundation
import UIKit


enum FilterType : String, CaseIterable {
    
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}

class MainModel {
        
    var images: [UIImage] = [UIImage(named: "q")!, UIImage(named: "w")!, UIImage(named: "e")!, UIImage(named: "r")!,
                                     UIImage(named: "t")!, UIImage(named: "y")!, UIImage(named: "u")!, UIImage(named: "i")!,
                                     UIImage(named: "o")!, UIImage(named: "p") ?? UIImage()]
    
    func EditingPhotos(selectedSegmentIndex: Int, collectionViewDataSource: CollectionViewDataSource, mainView: MainView) {
        let dispatchGroup = DispatchGroup()
        
        mainView.segmentControl.isEnabled = false
        
        if selectedSegmentIndex == 0 {
            let queue = DispatchQueue(label: "com.PhotoThreads.queue", attributes: .concurrent)
            for (index, image) in images.enumerated() {
                dispatchGroup.enter()
                mainView.segmentControl.isEnabled = false
                queue.async { [weak self] in
                    guard let self else { return }
                    let newImage = image.addFilter(filter: FilterType.allCases.randomElement()!)
                    images[index] = newImage
                    if var snapshot = collectionViewDataSource.dataSource?.snapshot() {
                        DispatchQueue.main.async {
                            snapshot.deleteItems([image])
                            snapshot.appendItems([newImage])
                            collectionViewDataSource.dataSource?.apply(snapshot)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                mainView.segmentControl.isEnabled = true
            }
        } else if selectedSegmentIndex == 1 {
            let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 1
            mainView.segmentControl.isEnabled = false
            dispatchGroup.enter()
            let operation = BlockOperation { [weak self] in
                guard let self else { return }
                for (index, image) in images.enumerated() {
                    let newImage = image.addFilter(filter: FilterType.allCases.randomElement()!)
                    images[index] = newImage
                    sleep(1)
                    if var snapshot = collectionViewDataSource.dataSource?.snapshot() {
                        DispatchQueue.main.async {
                            snapshot.deleteItems([image])
                            snapshot.appendItems([newImage])
                            collectionViewDataSource.dataSource?.apply(snapshot)
                        }
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                mainView.segmentControl.isEnabled = true
            }
            operationQueue.addOperation(operation)

        }
    }
    
    private func factorial(_ n: Int) -> Int {
        if n < 0 {
            return 0
        }
        var result = 1
        if n == 0 {
            return 1
        }
        for i in 1...min(n, 20) {
            result *= i
        }
        return result
    }
    
    func calculate() async -> Int {
            let someInt = Int.random(in: 1...20)
            let result = factorial(someInt)
        return result
        }
    }


extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        return UIImage(cgImage: cgImage!)
        }
}
