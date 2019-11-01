//
//  UILabel+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UILabelExtensionsTests: XCTestCase {
    func test_addCharacterSpacing_defaultSpacing() {
        let sut = UILabel()
        sut.text = "Test"

        sut.addCharacterSpacing()

        checkKernIsNotNil(for: sut.attributedText)
    }

    func test_addCharacterSpacing_addsCustomSpacing() {
        let sut = UILabel()
        sut.text = "Test"

        sut.addCharacterSpacing(kernValue: 2.0)

        checkKernIsNotNil(for: sut.attributedText)
    }

    func test_addCharacterSpacing_returnsIfTextIsNil() {
        let sut = UILabel()

        sut.addCharacterSpacing()

        XCTAssertNil(sut.attributedText)
    }
}

private extension UILabelExtensionsTests {
    func checkKernIsNotNil(for attributedText: NSAttributedString?) {
        XCTAssertNotNil(attributedText)

        var range = NSRange(location: 0, length: attributedText!.length)
        let kern = attributedText!.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: &range)
        XCTAssertNotNil(kern)
    }
}
