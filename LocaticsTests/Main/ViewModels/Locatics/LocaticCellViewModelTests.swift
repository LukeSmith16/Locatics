//
//  LocaticCellViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticCellViewModelTests: XCTestCase {

    var sut: LocaticCellViewModel!

    override func setUp() {
        sut = LocaticCellViewModel(locatic: MockLocatic())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_locatic_isNotNil() {
        XCTAssertNotNil(sut.locatic)
    }
}
