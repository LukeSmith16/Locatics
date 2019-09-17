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

    private var mockAddLocaticViewModel: MockAddLocaticViewModel!

    override func setUp() {
        mockAddLocaticViewModel = MockAddLocaticViewModel()

        sut = AddLocaticCardView.fromNib()
        sut.addLocaticViewModel = mockAddLocaticViewModel
    }

    override func tearDown() {
        sut = nil
        mockAddLocaticViewModel = nil
        super.tearDown()
    }

    func test_titleLabel_isNotNil() {
        XCTAssertNotNil(sut.titleLabel)
    }

    func test_locaticNameTextField_isNotNil() {
        XCTAssertNotNil(sut.locaticNameTextField)
    }

    func test_radiusLabel_isNotNil() {
        XCTAssertNotNil(sut.radiusLabel)
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

    func test_addLocaticTappedCalls_addLocaticWasTappedOnViewModel() {
        sut.addLocaticTapped(UIButton())

        XCTAssertTrue(mockAddLocaticViewModel.calledAddLocaticWasTapped)
    }

    func test_radiusSliderChangedCalls_radiusDidChangeOnViewModel() {
        sut.radiusSliderChanged(UISlider())

        XCTAssertTrue(mockAddLocaticViewModel.calledRadiusDidChange)
    }

    func test_radiusSliderChangedCalls_radiusDidChangeOnViewModelPassingSliderValue() {
        sut.radiusSlider.value = 2.0

        sut.radiusSliderChanged(UISlider())

        XCTAssertEqual(mockAddLocaticViewModel.radiusDidChangeValue!, sut.radiusSlider.value)
    }

    func test_settingAddLocaticViewModel_setsViewDelegate() {
        XCTAssertNotNil(sut.addLocaticViewModel)
        XCTAssertNotNil(sut.addLocaticViewModel!.viewDelegate)
    }

    func test_changeRadiusText_setsRadiusTextToPassedInValue() {
        sut.changeRadiusText("Changed value")

        XCTAssertEqual(sut.radiusLabel.text, "Changed value")
    }

    func test_addLocaticTapped_passesValuesFromViewToViewModel() {
        let locaticNameValue = "My Locatic"
        let radiusValue: Float = 50.0

        sut.locaticNameTextField.text = locaticNameValue
        sut.radiusSlider.value = radiusValue

        sut.addLocaticTapped(UIButton())

        XCTAssertEqual(mockAddLocaticViewModel.locaticNameValue, locaticNameValue)
        XCTAssertEqual(mockAddLocaticViewModel.radiusValue, radiusValue)
    }
}

private extension AddLocaticCardViewTests {
    class MockAddLocaticViewModel: AddLocaticViewModelInterface {

        var calledAddLocaticWasTapped = false
        var calledRadiusDidChange = false

        weak var viewDelegate: AddLocaticViewModelViewDelegate?

        var locaticNameValue: String?
        var radiusValue: Float?
        func addLocaticWasTapped(locaticName: String?, radius: Float) {
            calledAddLocaticWasTapped = true
            locaticNameValue = locaticName
            radiusValue = radius
        }

        var radiusDidChangeValue: Float?
        func radiusDidChange(_ newValue: Float) {
            calledRadiusDidChange = true
            radiusDidChangeValue = newValue
        }
    }
}
