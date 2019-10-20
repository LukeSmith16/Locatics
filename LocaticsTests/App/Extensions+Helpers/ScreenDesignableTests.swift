//
//  ScreenDesignableTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 20/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class ScreenDesignableTests: XCTestCase {
    func test_cornerRadius_isCalculatedFromScreenWidth() {
        XCTAssertEqual(ScreenDesignable.cornerRadius,
                       (UIScreen.main.bounds.width / 18.5).rounded(.down))
    }

    func test_alertHeight_isCalculatedFromScreenHeight() {
        XCTAssertEqual(ScreenDesignable.alertHeight,
                       UIScreen.main.bounds.height / 2.2)
    }
}
