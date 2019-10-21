//
//  LocaticsViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsListViewControllerTests: XCTestCase {

    var sut: LocaticsListViewController!

    override func setUp() {
        sut = LocaticsListViewController()
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_view_isNotNil() {
        XCTAssertNotNil(sut.view)
    }
}
