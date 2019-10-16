//
//  LocationRegionManagerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 16/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocationRegionManagerTests: XCTestCase {

    var sut: LocationRegionManager!

    private var mockLocaticStorage: MockLocaticStorage!
    private var mockLocaticVisitStorage: MockLocaticVisitStorage!

    override func setUp() {
        mockLocaticStorage = MockLocaticStorage()
        mockLocaticVisitStorage = MockLocaticVisitStorage()

        sut = LocationRegionManager(locaticStorage: mockLocaticStorage,
                                    locaticVisitStorage: mockLocaticVisitStorage)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_userDidEnterLocaticRegion_callsFetchLocaticsWithPredicateForRegionIdentifier() {
        let locatic = MockLocatic()
        sut.userDidEnterLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticStorage.calledFetchLocatics)
        XCTAssertEqual(mockLocaticStorage.changedPredicate!.predicateFormat,
                       "name == \"\(locatic.name)\"")
    }

    func test_userDidEnterLocaticRegion_callsInsertLocaticVisit() {
        sut.userDidEnterLocaticRegion(regionIdentifier: "TestLocatic")

        XCTAssertTrue(mockLocaticVisitStorage.calledInsertLocaticVisit)
    }

    func test_userDidEnterLocaticRegion_passesLocaticMatchingRegionIdentifier() {
        sut.userDidEnterLocaticRegion(regionIdentifier: "TestLocatic")

        XCTAssertEqual(mockLocaticVisitStorage.changedLocatic!.name,
                       "TestLocatic")
    }

    func test_userDidLeaveLocaticRegion_callsFetchLocaticsWithPredicateForRegionIdentifier() {
        let locatic = MockLocatic()
        sut.userDidLeaveLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticStorage.calledFetchLocatics)
        XCTAssertEqual(mockLocaticStorage.changedPredicate!.predicateFormat,
                       "name == \"\(locatic.name)\"")
    }

    func test_userDidLeaveLocaticRegion_callsUpdateLocaticVisit() {
        sut.userDidLeaveLocaticRegion(regionIdentifier: "TestLocatic")

        XCTAssertTrue(mockLocaticVisitStorage.calledUpdateLocaticVisit)
    }

    func test_userDidLeaveLocaticRegion_passesLocaticMatchingRegionIdentifier() {
        sut.userDidLeaveLocaticRegion(regionIdentifier: "TestLocatic")

        XCTAssertEqual(mockLocaticVisitStorage.changedLocaticVisit!.locatic.name,
                       "TestLocatic")
        XCTAssertNotNil(mockLocaticVisitStorage.changedExitDate)
    }

    func test_userDidLeaveLocaticRegion_returnsIfLocaticHasNoLocaticVisits() {
        let locatic = MockLocatic()
        locatic.locaticVisits = nil

        mockLocaticStorage.returnLocatics = [locatic]

        sut.userDidLeaveLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertFalse(mockLocaticVisitStorage.calledUpdateLocaticVisit)
    }

    func test_userDidEnterLocaticRegion_returnsIfLocaticIsNil() {
        mockLocaticStorage.shouldFail = true

        sut.userDidLeaveLocaticRegion(regionIdentifier: "Test")

        XCTAssertFalse(mockLocaticVisitStorage.calledInsertLocaticVisit)
    }

    func test_userDidLeaveLocaticRegion_returnsIfLocaticIsNil() {
        mockLocaticStorage.shouldFail = true

        sut.userDidLeaveLocaticRegion(regionIdentifier: "Test")

        XCTAssertFalse(mockLocaticVisitStorage.calledUpdateLocaticVisit)
    }
}
