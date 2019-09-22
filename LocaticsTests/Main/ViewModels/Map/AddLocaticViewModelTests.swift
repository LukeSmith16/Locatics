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
    private var mockLocaticEntryViewModelObserver: MockLocaticEntryViewModelObserver!

    override func setUp() {
        mockAddLocaticViewModelObserver = MockAddLocaticViewModelViewDelegate()
        mockLocaticEntryViewModelObserver = MockLocaticEntryViewModelObserver()

        sut = AddLocaticViewModel()
        sut.viewDelegate = mockAddLocaticViewModelObserver
        sut.locaticEntryValidationDelegate = mockLocaticEntryViewModelObserver
    }

    override func tearDown() {
        sut = nil
        mockAddLocaticViewModelObserver = nil
        mockLocaticEntryViewModelObserver = nil
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

    func test_isNewLocaticValuesValid_returnsFalseWhenInvalidName() {
        let result = sut.isNewLocaticValuesValid(name: "", radius: 25.0)
        XCTAssertFalse(result)
    }

    func test_isNewLocaticValuesValid_returnsFalseWhenInvalidRadius() {
        let result = sut.isNewLocaticValuesValid(name: "Valid name", radius: 5.0)
        XCTAssertFalse(result)
    }

    func test_isNewLocaticValuesValid_returnsTrueWhenValidValues() {
        let result = sut.isNewLocaticValuesValid(name: "Valid", radius: 25.0)
        XCTAssertTrue(result)
    }

    func test_isNewLocaticValuesValid_callsParentDelegateWhenNameErrorCatched() {
        _ = sut.isNewLocaticValuesValid(name: "", radius: 25.0)

        XCTAssertTrue(mockLocaticEntryViewModelObserver.calledValidationErrorOccured)
        XCTAssertEqual(AddLocaticEntryValidation.noNameEntered.localizedDescription,
                       mockLocaticEntryViewModelObserver.errorValue!)
    }

    func test_isNewLocaticValuesValid_callsParentDelegateWhenRadiusErrorCatched() {
        _ = sut.isNewLocaticValuesValid(name: "Valid", radius: 5.0)

        XCTAssertTrue(mockLocaticEntryViewModelObserver.calledValidationErrorOccured)
        XCTAssertEqual(AddLocaticEntryValidation.radiusTooSmall.localizedDescription,
                       mockLocaticEntryViewModelObserver.errorValue!)
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

    class MockLocaticEntryViewModelObserver: LocaticEntryValidationDelegate {
        var calledValidationErrorOccured = false

        var errorValue: String?
        func validationErrorOccured(_ error: String) {
            calledValidationErrorOccured = true
            errorValue = error
        }
    }
}
