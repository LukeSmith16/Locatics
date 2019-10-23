//
//  MockLocaticsListCollectionView.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import XCTest

@testable import Locatics
class MockLocaticsListCollectionView: LocaticsListCollectionView {
    var expectation: XCTestExpectation?

    var cellGotDequeued = false

    var calledPerformBatchUpdates = false
    var insertedItems = false
    var deletedItems = false
    var reloadedItems = false
    var calledAnimate = false

    var passedIndexPath: IndexPath?

    override func animate() {
        calledAnimate = true
        super.animate()
    }

    override func dequeueReusableCell(withReuseIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UICollectionViewCell {
        cellGotDequeued = true

        return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    override func insertItems(at indexPaths: [IndexPath]) {
        insertedItems = true
        passedIndexPath = indexPaths.first

        super.insertItems(at: indexPaths)
    }

    override func deleteItems(at indexPaths: [IndexPath]) {
        deletedItems = true
        passedIndexPath = indexPaths.first

        super.deleteItems(at: indexPaths)
    }

    override func reloadItems(at indexPaths: [IndexPath]) {
        reloadedItems = true
        passedIndexPath = indexPaths.first

        super.reloadItems(at: indexPaths)
    }

    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        calledPerformBatchUpdates = true
        super.performBatchUpdates(updates, completion: completion)
        expectation?.fulfill()
    }
}
