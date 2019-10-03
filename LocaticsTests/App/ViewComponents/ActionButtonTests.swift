//
//  ActionButtonTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class ActionButtonTests: XCTestCase {
    func test_actionButton_withSaveValues() {
        let sut = ActionButton()
        sut.setup(actionStyle: .save, actionTitle: "Save title")

        XCTAssertTrue(sut.style == ActionButtonStyle.save)
        XCTAssertEqual(sut.actionTitle, "Save title")
        XCTAssertEqual(sut.backgroundColor, UIColor(colorTheme: .Interactable_Main))
        XCTAssertEqual(sut.layer.cornerRadius, 25.0)

        XCTAssertEqual(sut.title(for: .normal), sut.actionTitle)
        XCTAssertEqual(sut.titleColor(for: .normal), sut.style.textColor)
        XCTAssertEqual(sut.titleLabel!.font, sut.style.textFont)
    }
}
