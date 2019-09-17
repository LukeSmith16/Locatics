//
//  AddLocaticViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class AddLocaticViewModelTests: XCTestCase {

    var sut: AddLocaticViewModel!

    private var mockAddLocaticViewModelObserver: MockAddLocaticViewModelViewDelegate!

    override func setUp() {
        mockAddLocaticViewModelObserver = MockAddLocaticViewModelViewDelegate()

        sut = AddLocaticViewModel()
        sut.viewDelegate = mockAddLocaticViewModelObserver
    }

    override func tearDown() {
        sut = nil
        mockAddLocaticViewModelObserver = nil
        super.tearDown()
    }

    func test_addLocaticEntryValidation_values() {
        XCTAssertEqual(AddLocaticEntryValidation.noNameEntered.localizedDescription,
                       "Please give your Locatic a name.")
        XCTAssertEqual(AddLocaticEntryValidation.radiusTooSmall.localizedDescription,
                       "Please specify a larger radius for your locatic.")
    }

    func test_radiusDidChangeCalls_viewDelegateChangeRadiusText() {
        sut.radiusDidChange(10.0)

        XCTAssertTrue(mockAddLocaticViewModelObserver.calledChangeRadiusText)
    }

    func test_radiusDidChangePassesValueTo_viewDelegateChangeRadiusText() {
        sut.radiusDidChange(10.34)

        XCTAssertEqual(mockAddLocaticViewModelObserver.changeRadiusTextValue!, "Radius: 10 meters")
    }

    func test_validateLocaticName_throwsErrorWhenNameIsNil() {
        XCTAssertThrowsError(try sut.validateLocaticName(nil)) { error in
            guard let error = error as? AddLocaticEntryValidation else {
                fatalError("Error should be of type 'AddLocaticEntryValidation'")
            }

            XCTAssertEqual(error, AddLocaticEntryValidation.noNameEntered)
        }
    }

    func test_validateLocaticName_throwsErrorWhenNameIsEmpty() {
        XCTAssertThrowsError(try sut.validateLocaticName("")) { error in
            guard let error = error as? AddLocaticEntryValidation else {
                fatalError("Error should be of type 'AddLocaticEntryValidation'")
            }

            XCTAssertEqual(error, AddLocaticEntryValidation.noNameEntered)
        }
    }

    func test_validateLocaticName_doesNotThrowErrorWhenNameIsValid() {
        XCTAssertNoThrow(try sut.validateLocaticName("Valid name"))
    }

    func test_validateLocaticRadius_throwsErrorWhenRadiusIsLessThanTen() {
        XCTAssertThrowsError(try sut.validateLocaticRadius(5.0)) { error in
            guard let error = error as? AddLocaticEntryValidation else {
                fatalError("Error should be of type 'AddLocaticEntryValidation'")
            }

            XCTAssertEqual(error, AddLocaticEntryValidation.radiusTooSmall)
        }
    }

    func test_validateLocaticRadius_doesNotThrowErrorWhenRadiusIsValid() {
        XCTAssertNoThrow(try sut.validateLocaticRadius(25.0))
    }
}

private extension AddLocaticViewModelTests {
    class MockAddLocaticViewModelViewDelegate: AddLocaticViewModelViewDelegate {
        var calledChangeRadiusText = false

        var changeRadiusTextValue: String?
        func changeRadiusText(_ newRadiusText: String) {
            calledChangeRadiusText = true
            changeRadiusTextValue = newRadiusText
        }
    }
}
