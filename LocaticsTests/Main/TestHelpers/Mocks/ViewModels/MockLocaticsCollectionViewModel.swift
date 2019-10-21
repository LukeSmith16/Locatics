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
    weak var viewDelegate: LocaticsCollectionViewModelViewDelegate?

    func locaticsCount() -> Int {
        return 0
    }
}
