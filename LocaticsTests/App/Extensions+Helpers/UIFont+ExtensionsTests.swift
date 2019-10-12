//
//  UIFont+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UIFontExtensionsTests: XCTestCase {

    func test_installedRegularH1() {
        let font = Font.init(.installed(.HelveticaRegular), size: .standard(.h1)).instance

        XCTAssertEqual(font.fontName, "Helvetica")
        XCTAssertEqual(font.pointSize, 18.0)
    }

    func test_installed_regularH2() {
        let font = Font.init(.installed(.HelveticaRegular), size: .standard(.h2)).instance

        XCTAssertEqual(font.fontName, "Helvetica")
        XCTAssertEqual(font.pointSize, 14.0)
    }

    func test_installed_regularH3() {
        let font = Font.init(.installed(.HelveticaRegular), size: .standard(.h3)).instance

        XCTAssertEqual(font.fontName, "Helvetica")
        XCTAssertEqual(font.pointSize, 12.0)
    }

    func test_installed_regularH4() {
        let font = Font.init(.installed(.HelveticaRegular), size: .standard(.h4)).instance

        XCTAssertEqual(font.fontName, "Helvetica")
        XCTAssertEqual(font.pointSize, 9.0)
    }

    func test_installed_regularCustomSize() {
        let font = Font.init(.installed(.HelveticaRegular), size: .custom(20)).instance

        XCTAssertEqual(font.fontName, "Helvetica")
        XCTAssertEqual(font.pointSize, 20.0)
    }
}
