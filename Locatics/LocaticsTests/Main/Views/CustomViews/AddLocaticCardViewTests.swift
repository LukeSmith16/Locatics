//
//  AddLocaticCardViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 14/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class AddLocaticCardViewTests: XCTestCase {

    var sut: AddLocaticCardView!

    override func setUp() {
        sut = AddLocaticCardView.fromNib()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_titleLabel_isNotNil() {
        XCTAssertNotNil(sut.titleLabel)
    }

    func test_locaticNameTextField_isNotNil() {
        XCTAssertNotNil(sut.locaticNameTextField)
    }

    func test_radiusSlider_isNotNil() {
        XCTAssertNotNil(sut.radiusSlider)

        XCTAssertEqual(sut.radiusSlider.allTargets.count, 1)

        XCTAssertEqual(sut.radiusSlider.minimumValue, 0)
        XCTAssertEqual(sut.radiusSlider.maximumValue, 100)

        XCTAssertTrue(sut.radiusSlider is SliderControl)
    }

    func test_addNewLocaticButton_isNotNil() {
        XCTAssertNotNil(sut.addNewLocaticButton)

        XCTAssertEqual(sut.addNewLocaticButton.allTargets.count, 1)

        guard let addLocaticButton = sut.addNewLocaticButton as? ActionButton else {
            XCTFail("AddLocaticButton should be of type ActionButton")
            return
        }

        XCTAssertEqual(addLocaticButton.actionTitle, "Add new Locatic")
    }

    func test_shadowRadius_isFour() {
        XCTAssertEqual(sut.layer.shadowRadius, 4.0)
    }

    func test_topCornerRadius_isTwentyFive() {
        XCTAssertEqual(sut.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        XCTAssertEqual(sut.layer.cornerRadius, 25.0)
    }
}
