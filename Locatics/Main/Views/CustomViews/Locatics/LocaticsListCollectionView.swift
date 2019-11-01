//
//  LocaticsListCollectionView.swift
//  Locatics
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable force_cast

import UIKit
import ViewAnimator

class LocaticsListCollectionView: UICollectionView {
    var locaticsCollectionViewModel: LocaticsCollectionViewModelInterface? {
        didSet {
            locaticsCollectionViewModel?.viewDelegate = self
            setupCollectionView()
        }
    }

    func animate() {
        self.performBatchUpdates({
            self.alpha = 1.0
            UIView.animate(views: [self],
                           animations: [AnimationType.from(direction: .bottom, offset: 100)],
                           duration: 0.7)
        }, completion: nil)
    }
}

private extension LocaticsListCollectionView {
    func setupCollectionView() {
        setupDSAndDelegate()
        setupLayout()
        registerLocaticCell()
    }

    func setupDSAndDelegate() {
        self.dataSource = self
        self.delegate = self
    }

    func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width,
                                 height: ScreenDesignable.cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 35
        layout.scrollDirection = .vertical

        self.collectionViewLayout = layout
    }

    func registerLocaticCell() {
        let nib = UINib(nibName: "LocaticCollectionViewCell", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "LocaticCollectionViewCell")
    }
}

extension LocaticsListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locaticsCollectionViewModel!.locaticsCount()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let locaticCell = dequeueReusableCell(withReuseIdentifier: "LocaticCollectionViewCell",
                                              for: indexPath) as! LocaticCollectionViewCell

        let locaticCellViewModel = locaticsCollectionViewModel?.locaticAtIndex(indexPath)
        locaticCell.locaticCellViewModel = locaticCellViewModel

        return locaticCell
    }
}

extension LocaticsListCollectionView: UICollectionViewDelegate {}

extension LocaticsListCollectionView: LocaticsCollectionViewModelViewDelegate {
    func locaticCellViewModelWasAdded(atIndex: Int) {
        self.performBatchUpdates({
            let indexPath = IndexPath(item: atIndex, section: 0)
            self.insertItems(at: [indexPath])
        }, completion: nil)
    }

    func locaticCellViewModelWasRemoved(atIndex: Int) {
        self.performBatchUpdates({
            let indexPath = IndexPath(item: atIndex, section: 0)
            self.deleteItems(at: [indexPath])
        }, completion: nil)
    }

    func locaticCellViewModelWasUpdated(atIndex: Int) {
        self.performBatchUpdates({
            let indexPath = IndexPath(item: atIndex, section: 0)
            self.reloadItems(at: [indexPath])
        }, completion: nil)
    }
}
