//
//  LocaticsViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsViewModelTests: XCTestCase {

    var sut: LocaticsViewModel!

    override func setUp() {
        sut = LocaticsViewModel(locaticsCollectionViewModel: MockLocaticsCollectionViewModel())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_locaticsCollectionViewModel_isNotNil() {
        XCTAssertNotNil(sut.locaticsCollectionViewModel)
    }
}
