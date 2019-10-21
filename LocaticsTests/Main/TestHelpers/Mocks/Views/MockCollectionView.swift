//
//  MockCollectionView.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class MockCollectionView: UICollectionView {
    var cellGotDequeued = false

    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        cellGotDequeued = true

        return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
