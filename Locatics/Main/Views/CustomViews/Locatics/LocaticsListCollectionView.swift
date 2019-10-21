//
//  LocaticsListCollectionView.swift
//  Locatics
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class LocaticsListCollectionView: UICollectionView {
    var locaticsCollectionViewModel: LocaticsCollectionViewModelInterface? {
        didSet {
            locaticsCollectionViewModel?.viewDelegate = self
            setupCollectionView()
        }
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
        layout.minimumLineSpacing = 25
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
        guard let locaticCell = dequeueReusableCell(withReuseIdentifier: "LocaticCollectionViewCell", for: indexPath) as? LocaticCollectionViewCell else {
            return UICollectionViewCell()
        }

//        locaticCell.configure()

        return locaticCell
    }
}

extension LocaticsListCollectionView: UICollectionViewDelegate {

}

extension LocaticsListCollectionView: LocaticsCollectionViewModelViewDelegate {

}
