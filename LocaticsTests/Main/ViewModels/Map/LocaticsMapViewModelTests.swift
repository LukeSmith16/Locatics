//
//  LocaticsMapViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

// swiftlint:disable identifier_name

@testable import Locatics
class LocaticsMapViewModelTests: XCTestCase {

    var sut: LocaticsMapViewModel!

    private var mockLocaticsMapViewModelViewObserver: MockLocaticsMapViewModelViewDelegate!
    private var mockLocaticsMainLocationPinCoordinateObserver: MockLocaticsMainLocationPinCoordinateDelegate!

    override func setUp() {
        sut = LocaticsMapViewModel(locaticStorage: MockLocaticStorage())

        mockLocaticsMapViewModelViewObserver = MockLocaticsMapViewModelViewDelegate()
        mockLocaticsMainLocationPinCoordinateObserver = MockLocaticsMainLocationPinCoordinateDelegate()

        sut.viewDelegate = mockLocaticsMapViewModelViewObserver
        sut.locationPinCoordinateDelegate = mockLocaticsMainLocationPinCoordinateObserver
    }

    override func tearDown() {
        mockLocaticsMapViewModelViewObserver = nil
        mockLocaticsMainLocationPinCoordinateObserver = nil
        sut = nil
        super.tearDown()
    }

    func test_goToUserRegion_callsZoomToUserLocation() {
        sut.goToUserRegion()

        XCTAssertTrue(mockLocaticsMapViewModelViewObserver.calledZoomToUserLocation)

        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedLatMeters!,
                       750)
        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedLonMeters!,
                       750)
    }

    func test_updatePinAnnotationRadius_callsUpdatePinAnnotationRadius() {
        sut.updatePinAnnotationRadius(toRadius: 85)

        XCTAssertTrue(mockLocaticsMapViewModelViewObserver.calledUpdatePinAnnotationRadius)
        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.updatePinAnnotationRadiusPassedRadius!,
                       85)
    }

    func test_getLocationPinCoordinate_callsPinCoordinateDelegate() {
        let result = sut.getLocationPinCoordinate()

        XCTAssertTrue(mockLocaticsMainLocationPinCoordinateObserver.calledGetPinCurrentLocationCoordinate)

        XCTAssertEqual(result.latitude, 10)
        XCTAssertEqual(result.longitude, 7)
    }
}
