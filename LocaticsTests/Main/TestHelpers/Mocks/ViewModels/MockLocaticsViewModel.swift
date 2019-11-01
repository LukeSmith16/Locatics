//
//  MockLocaticsViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsViewModel: LocaticsViewModelInterface {
    weak var viewDelegate: LocaticsViewModelViewDelegate?

    var locaticsCollectionViewModel: LocaticsCollectionViewModelInterface {
        return MockLocaticsCollectionViewModel()
    }
}
