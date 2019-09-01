//
//  UIColor+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable identifier_name

import XCTest

@testable import Locatics
class UIColorExtensionsTests: XCTestCase {
    func test_colorConstValues() {
        let background = ColorTheme.Background
        XCTAssertEqual(background.rawValue, "background")

        let interactable_main = ColorTheme.Interactable_Main
        XCTAssertEqual(interactable_main.rawValue, "interactable_main")

        let interactable_secondary = ColorTheme.Interactable_Secondary
        XCTAssertEqual(interactable_secondary.rawValue, "interactable_secondary")

        let title_main = ColorTheme.Title_Main
        XCTAssertEqual(title_main.rawValue, "title_main")

        let title_secondary = ColorTheme.Title_Secondary
        XCTAssertEqual(title_secondary.rawValue, "title_secondary")
    }

    func test_colorInitReturnsSameColorFromSuperInit() {
        let colorInit = UIColor(colorTheme: .Background)
        let superInit = UIColor(named: "background")

        XCTAssertNotNil(superInit)

        XCTAssertEqual(colorInit, superInit!)
    }
}
