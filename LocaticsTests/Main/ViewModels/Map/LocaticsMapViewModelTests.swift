//
//  LocaticsMapViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

// swiftlint:disable type_name
// swiftlint:disable identifier_name

@testable import Locatics
class LocaticsMapViewModelTests: XCTestCase {

    var sut: LocaticsMapViewModel!

    private var mockLocaticsMapViewModelViewObserver: MockLocaticsMapViewModelViewDelegate!
    private var mockLocaticsMainLocationPinCoordinateObserver: MockLocaticsMainLocationPinCoordinateDelegate!

    override func setUp() {
        sut = LocaticsMapViewModel()

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
                       2000)
        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedLonMeters!,
                       2000)
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

private extension LocaticsMapViewModelTests {
    class MockLocaticsMapViewModelViewDelegate: LocaticsMapViewModelViewDelegate {
        var calledZoomToUserLocation = false
        var calledUpdateMapRegion = false
        var calledUpdatePinAnnotationRadius = false

        var passedCoordinate: Coordinate?
        var passedLatMeters: Double?
        var passedLonMeters: Double?

        func zoomToUserLocation(latMeters: Double, lonMeters: Double) {
            calledZoomToUserLocation = true
            passedLatMeters = latMeters
            passedLonMeters = lonMeters
        }

        func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double) {
            calledUpdateMapRegion = true
            passedCoordinate = location
            passedLatMeters = latMeters
            passedLonMeters = lonMeters
        }

        var updatePinAnnotationRadiusPassedRadius: Double?
        func updatePinAnnotationRadius(toRadius radius: Double) {
            calledUpdatePinAnnotationRadius = true
            updatePinAnnotationRadiusPassedRadius = radius
        }
    }

    class MockLocaticsMainLocationPinCoordinateDelegate: LocaticsMainLocationPinCoordinateDelegate {
        var calledGetPinCurrentLocationCoordinate = false

        func getPinCurrentLocationCoordinate() -> Coordinate {
            calledGetPinCurrentLocationCoordinate = true
            return Coordinate(latitude: 10, longitude: 7)
        }
    }
}
