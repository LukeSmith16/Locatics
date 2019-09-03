//
//  OnboardingViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingViewControllerTests: XCTestCase {

    var sut: OnboardingViewController!

    override func setUp() {
        sut = OnboardingViewController()
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewIsNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_isPageViewControllerDataSource() {
        XCTAssertNotNil(sut.dataSource)
    }

    func test_isPageViewControllerDelegate() {
        XCTAssertNotNil(sut.delegate)
    }
}
