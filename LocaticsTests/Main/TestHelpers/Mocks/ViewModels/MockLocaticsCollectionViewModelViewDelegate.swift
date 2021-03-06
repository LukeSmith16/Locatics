//
//  MockLocaticsCollectionViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
//swiftlint:disable identifier_name

@testable import Locatics
class MockLocaticsCollectionViewModelViewDelegate: LocaticsCollectionViewModelViewDelegate {
    var calledLocaticCellViewModelWasAdded = false
    var calledLocaticCellViewModelWasRemoved = false
    var calledLocaticCellViewModelWasUpdated = false
    var calledReloadData = false

    var passedLocaticCellViewModelWasAdded: Int?
    var passedLocaticCellViewModelWasRemoved: Int?
    var passedLocaticCellViewModelWasUpdatedIndex: Int?

    func locaticCellViewModelWasAdded(atIndex: Int) {
        calledLocaticCellViewModelWasAdded = true
        passedLocaticCellViewModelWasAdded = atIndex
    }

    func locaticCellViewModelWasRemoved(atIndex: Int) {
        calledLocaticCellViewModelWasRemoved = true
        passedLocaticCellViewModelWasRemoved = atIndex
    }

    func locaticCellViewModelWasUpdated(atIndex: Int) {
        calledLocaticCellViewModelWasUpdated = true
        passedLocaticCellViewModelWasUpdatedIndex = atIndex
    }

    func reloadData() {
        calledReloadData = true
    }
}
