//
//  LocaticsMapViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Locatics
class LocaticsMapViewModelTests: XCTestCase {

    private var mockLocaticsViewModelViewObserver: MockLocaticsMapViewModelViewDelegate!
    private var mockLocationManager: MockLocationManager!
    var sut: LocaticsMapViewModel!

    override func setUp() {
        mockLocationManager = MockLocationManager()
        mockLocaticsViewModelViewObserver = MockLocaticsMapViewModelViewDelegate()

        sut = LocaticsMapViewModel()
        sut.viewDelegate = mockLocaticsViewModelViewObserver
        sut.locationManager = mockLocationManager
    }

    override func tearDown() {
        mockLocationManager = nil
        mockLocaticsViewModelViewObserver = nil
        sut = nil
        super.tearDown()
    }

    func test_locationManager_isNotNil() {
        XCTAssertNotNil(sut.locationManager)
        XCTAssertNotNil(sut.locationManager!.locationDelegate)
    }

    func test_mainTitle_returnsLastVisitedLocationTitle() {
        let mainTitle = sut.getMainTitle()

        XCTAssertEqual(mainTitle, mockLocationManager.lastVisitedLocation!.description)
    }

    func test_mainTitle_returnsFetchingLocationIfVisitedLocationIsNil() {
        mockLocationManager.lastVisitedLocation = nil
        mockLocationManager.locationBlockLocationValue = VisitedLocation(
        CLLocationCoordinate2D(latitude: 25.0, longitude: 30.0),
        date: Date(),
        description: "Test title")

        let mainTitle = sut.getMainTitle()

        XCTAssertEqual(mainTitle, "Fetching location...")
        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledSetNavigationTitle)
    }

    func test_setCurrentLocationName_callsViewDelegateIfErrorOccurs() {
        mockLocationManager.lastVisitedLocation = nil
        mockLocationManager.locationBlockErrorValue = .locationNotFound

        _ = sut.getMainTitle()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)
    }

    func test_subtitle_returnsLastVisitedLocationArrivalDate() {
        let arrivalDate = Date()
        mockLocationManager.lastVisitedLocation = VisitedLocation(
            CLLocationCoordinate2D(latitude: 25.0, longitude: 30.0),
            date: arrivalDate,
            description: "Test title")

        let arrivalDateFormatted = DateFormatterManager.hoursMinutes(from: arrivalDate)
        let subtitle = sut.getSubtitle()

        XCTAssertEqual(subtitle, "Since " + arrivalDateFormatted)
    }

    func test_subtitle_returnsJustNowIfLastVisitedLocationIsNil() {
        mockLocationManager.lastVisitedLocation = nil
        mockLocationManager.locationBlockErrorValue = .locationNotFound

        let subtitle = sut.getSubtitle()

        XCTAssertEqual(subtitle, "Just now")
    }

    func test_locationPermissionsNotAuthorised_callsShowAlert() {
        sut.locationPermissionsNotAuthorised()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)
    }
}

private extension LocaticsMapViewModelTests {
    class MockLocaticsMapViewModelViewDelegate: LocaticsMapViewModelViewDelegate {
        var calledSetNavigationTitle = false
        var calledShowAlert = false

        func setNavigationTitle(_ title: String) {
            calledSetNavigationTitle = true
        }

        func showAlert(title: String, message: String) {
            calledShowAlert = true
        }
    }
}
