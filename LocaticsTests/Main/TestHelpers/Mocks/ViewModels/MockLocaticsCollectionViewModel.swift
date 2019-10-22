//
//  MockLocaticsCollectionViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsCollectionViewModel: LocaticsCollectionViewModelInterface {
    var calledLocaticAtIndex = false

    weak var viewDelegate: LocaticsCollectionViewModelViewDelegate?
    var locaticCellViewModels: [LocaticCellViewModelInterface] = []

    var locaticsReturnCount = 0
    func locaticsCount() -> Int {
        return locaticsReturnCount
    }

    func locaticAtIndex(_ index: IndexPath) -> LocaticCellViewModelInterface {
        calledLocaticAtIndex = true
        return locaticCellViewModels[index.item]
    }
}
