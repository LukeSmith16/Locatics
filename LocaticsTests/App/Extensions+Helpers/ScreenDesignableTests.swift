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
    func test_onboardingBackgroundTextViewHeight_isCalculatedFromSceenHeight() {
        XCTAssertEqual(ScreenDesignable.onboardingBackgroundTextViewHeight,
                       UIScreen.main.bounds.height * 0.3425)
    }

    func test_cornerRadius_isCalculatedFromScreenWidth() {
        XCTAssertEqual(ScreenDesignable.cornerRadius,
                       (UIScreen.main.bounds.width / 18.5).rounded(.down))
    }

    func test_alertHeight_isCalculatedFromScreenHeight() {
        XCTAssertEqual(ScreenDesignable.alertHeight,
                       UIScreen.main.bounds.height / 2.2)
    }

    func test_cellHeight_isCalculatedFromScreenHeight() {
        XCTAssertEqual(ScreenDesignable.cellHeight,
                       UIScreen.main.bounds.height / 3.4)
    }
}
