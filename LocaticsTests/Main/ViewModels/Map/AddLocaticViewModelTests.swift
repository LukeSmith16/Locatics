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
    private var mockLocaticEntryValidationObserver: MockLocaticEntryValidationDelegate!
    private var mockLocaticPinLocationObserver: MockLocaticPinLocationDelegate!

    private var mockLocaticStorge: MockLocaticStorage!

    override func setUp() {
        mockAddLocaticViewModelObserver = MockAddLocaticViewModelViewDelegate()
        mockLocaticEntryValidationObserver = MockLocaticEntryValidationDelegate()
        mockLocaticStorge = MockLocaticStorage()
        mockLocaticPinLocationObserver = MockLocaticPinLocationDelegate()

        sut = AddLocaticViewModel(locaticStorage: mockLocaticStorge)
        sut.viewDelegate = mockAddLocaticViewModelObserver
        sut.locaticEntryValidationDelegate = mockLocaticEntryValidationObserver
        sut.locaticPinLocationDelegate = mockLocaticPinLocationObserver
    }

    override func tearDown() {
        sut = nil
        mockAddLocaticViewModelObserver = nil
        mockLocaticEntryValidationObserver = nil
        mockLocaticStorge = nil
        mockLocaticPinLocationObserver = nil
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

    func test_locaticIconDidChange_updatesLocaticIconPathWithTagZero() {
        sut.locaticIconDidChange(0)

        sut.addLocaticWasTapped(locaticName: "Test", radius: 15)

        XCTAssertEqual(mockLocaticStorge.changedIconPath!, "locaticIcon")
    }

    func test_locaticIconDidChange_updatesLocaticIconPathWithTagOne() {
        sut.locaticIconDidChange(1)

        sut.addLocaticWasTapped(locaticName: "Test", radius: 15)

        XCTAssertEqual(mockLocaticStorge.changedIconPath!, "homeLocaticIcon")
    }

    func test_locaticIconDidChange_updatesLocaticIconPathWithTagTwo() {
        sut.locaticIconDidChange(2)

        sut.addLocaticWasTapped(locaticName: "Test", radius: 15)

        XCTAssertEqual(mockLocaticStorge.changedIconPath!, "activityLocaticIcon")
    }

    func test_locaticIconDidChange_updatesLocaticIconPathWithTagThree() {
        sut.locaticIconDidChange(3)

        sut.addLocaticWasTapped(locaticName: "Test", radius: 15)

        XCTAssertEqual(mockLocaticStorge.changedIconPath!, "workLocaticIcon")
    }

    func test_locaticIconDidChange_withInvalidTagUsesDefaultIconPath() {
        sut.locaticIconDidChange(10)

        sut.addLocaticWasTapped(locaticName: "Test", radius: 15)

        XCTAssertEqual(mockLocaticStorge.changedIconPath!, "")
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

        XCTAssertTrue(mockLocaticEntryValidationObserver.calledValidationErrorOccured)
        XCTAssertEqual(AddLocaticEntryValidation.noNameEntered.localizedDescription,
                       mockLocaticEntryValidationObserver.errorValue!)
    }

    func test_isNewLocaticValuesValid_callsParentDelegateWhenRadiusErrorCatched() {
        _ = sut.isNewLocaticValuesValid(name: "Valid", radius: 5.0)

        XCTAssertTrue(mockLocaticEntryValidationObserver.calledValidationErrorOccured)
        XCTAssertEqual(AddLocaticEntryValidation.radiusTooSmall.localizedDescription,
                       mockLocaticEntryValidationObserver.errorValue!)
    }

    func test_addLocaticWasTapped_callsLocaticStorage() {
        sut.addLocaticWasTapped(locaticName: "Locatic Name", radius: 15.0)

        XCTAssertTrue(mockLocaticStorge.calledInsertLocatic)
    }

    func test_addLocaticWasTapped_callsGetPinCurrentLocationCoordinate() {
        sut.addLocaticWasTapped(locaticName: "Locatic Name", radius: 15.0)

        XCTAssertTrue(mockLocaticPinLocationObserver.calledGetPinCurrentLocationCoordinate)
    }

    func test_addLocaticWasTapped_callsLocaticStoragePassingValues() {
        sut.addLocaticWasTapped(locaticName: "Locatic Name", radius: 15.0)

        XCTAssertEqual(mockLocaticStorge.changedName!, "Locatic Name")
        XCTAssertEqual(mockLocaticStorge.changedRadius!, 15.0)

        XCTAssertEqual(mockLocaticStorge.changedLongitude!, 51.5)
        XCTAssertEqual(mockLocaticStorge.changedLatitude!, 25.0)
    }

    func test_addLocaticWasTapped_callsValidationErrorIfFails() {
        mockLocaticStorge.shouldFail = true
        sut.addLocaticWasTapped(locaticName: "Name", radius: 15.0)

        XCTAssertTrue(mockLocaticEntryValidationObserver.calledValidationErrorOccured)
        XCTAssertEqual(mockLocaticEntryValidationObserver.errorValue!,
                       "Could not find object matching ID.")
    }

    func test_isNewLocaticValuesValid_returnsFalseByDefault() {
        XCTAssertFalse(sut.isNewLocaticValuesValid(name: "", radius: 10.0))
    }

    func test_addLocaticWasTapped_returnsWhenLocaticPinLocationDelegateIsNil() {
        sut.locaticPinLocationDelegate = nil
        sut.addLocaticWasTapped(locaticName: "Test", radius: 15.0)

        XCTAssertFalse(mockLocaticStorge.calledInsertLocatic)
    }

    func test_addLocaticWasTapped_callsLocaticWasSuccessfullyAddedIfValidationPasses() {
        sut.addLocaticWasTapped(locaticName: "Valid name", radius: 15.0)
        XCTAssertTrue(mockLocaticEntryValidationObserver.calledCloseAddLocaticCardView)
    }

    func test_locaticPinLocationDelegate_updatePinRadius() {
        sut.radiusDidChange(5)

        XCTAssertTrue(mockLocaticPinLocationObserver.calledUpdatePinRadius)
        XCTAssertEqual(mockLocaticPinLocationObserver.newRadius!, 5)
    }
}
