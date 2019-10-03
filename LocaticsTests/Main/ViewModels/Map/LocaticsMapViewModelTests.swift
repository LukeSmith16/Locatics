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

    var sut: LocaticsMapViewModel!

    private var mockLocaticsViewModelViewObserver: MockLocaticsMapViewModelViewDelegate!
    private var mockLocationManager: MockLocationManager!

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

    func test_getUserRegion_callsGetCurrentUserLocation() {
        mockLocationManager.locationBlockErrorValue = .locationNotFound

        sut.getUserRegion()

        XCTAssertTrue(mockLocationManager.calledFindCurrentLocation)
    }

    func test_getUserRegion_callsViewDelegateShowAlertWhenError() {
        mockLocationManager.locationBlockErrorValue = .locationNotFound

        sut.getUserRegion()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)
    }

    func test_getUserRegion_callsViewDelegateUpdateMapRegionWhenSuccess() {
        let visitedLocation = VisitedLocation(MockLocation().coordinate, date: Date(), description: "Desc")
        mockLocationManager.locationBlockLocationValue = visitedLocation

        sut.getUserRegion()

        XCTAssertFalse(mockLocaticsViewModelViewObserver.calledShowAlert)
        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledUpdateMapRegion)

        XCTAssertTrue(mockLocaticsViewModelViewObserver.location.latitude == visitedLocation.coordinate.latitude)
        XCTAssertTrue(mockLocaticsViewModelViewObserver.location.longitude == visitedLocation.coordinate.longitude)

        XCTAssertEqual(mockLocaticsViewModelViewObserver.latMeter, 10000)
        XCTAssertEqual(mockLocaticsViewModelViewObserver.lonMeter, 10000)
    }

    func test_addLocaticWasTapped_callsShowAddLocaticCardViewWithPassedValues() {
        sut.addLocaticWasTapped()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledAddLocaticCardView)

        XCTAssertEqual(mockLocaticsViewModelViewObserver.latMeter, 0.0)
        XCTAssertEqual(mockLocaticsViewModelViewObserver.lonMeter, 0.0)
    }

    func test_addLocaticWasTapped_callsShowLocationMarkerPin() {
        sut.addLocaticWasTapped()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowLocationMarkerPin)
    }

    func test_validationErrorOccured_callsShowAlert() {
        sut.validationErrorOccured("Error in adding Locatic")

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)
    }

    func test_validationErrorOccured_callsShowAlertWithPassedValues() {
        sut.validationErrorOccured("Error in adding Locatic")

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedMessage!,
                       "Error in adding Locatic")
        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedTitle!,
                       "Error adding Locatic")
    }

    func test_closeAddLocaticCardView_callsCloseAddLocaticCardView() {
        sut.closeAddLocaticCardView()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledCloseAddLocaticCardView)
    }

    func test_getPinCurrentLocationCoordinate_returnsVCMapViewCenterCoordinate() {
        let pinLocationCoordinate = sut.getPinCurrentLocationCoordinate()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledGetCenterMapCoordinate)

        XCTAssertEqual(pinLocationCoordinate.latitude,
                       mockLocaticsViewModelViewObserver.getCenterMapCoordinate().latitude)
        XCTAssertEqual(pinLocationCoordinate.longitude,
                       mockLocaticsViewModelViewObserver.getCenterMapCoordinate().longitude)
    }
}

private extension LocaticsMapViewModelTests {
    class MockLocaticsMapViewModelViewDelegate: LocaticsMapViewModelViewDelegate {
        var calledSetNavigationTitle = false
        var calledShowAlert = false
        var calledUpdateMapRegion = false
        var calledShowAddLocaticCardView = false
        var calledAddLocaticCardView = false
        var calledCloseAddLocaticCardView = false
        var calledZoomToUserLocation = false
        var calledGetCenterMapCoordinate = false
        var calledShowLocationMarkerPin = false
        var calledHideTabBar = false

        var location: CLLocationCoordinate2D!
        var latMeter: Double!
        var lonMeter: Double!

        func setNavigationTitle(_ title: String) {
            calledSetNavigationTitle = true
        }

        var passedTitle: String?
        var passedMessage: String?
        func showAlert(title: String, message: String) {
            self.passedTitle = title
            self.passedMessage = message

            calledShowAlert = true
        }

        func zoomToUserLocation(latMeters: Double, lonMeters: Double) {
            self.latMeter = latMeters
            self.lonMeter = lonMeters

            calledZoomToUserLocation = true
        }

        func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double) {
            self.location = location
            self.latMeter = latMeters
            self.lonMeter = lonMeters

            calledUpdateMapRegion = true
        }

        func showAddLocaticCardView() {
            calledAddLocaticCardView = true
        }

        func showLocationMarkerPin() {
            calledShowLocationMarkerPin = true
        }

        func getCenterMapCoordinate() -> Coordinate {
            calledGetCenterMapCoordinate = true
            return Coordinate(latitude: 25.0, longitude: 20.0)
        }

        func closeAddLocaticCardView() {
            calledCloseAddLocaticCardView = true
        }

        func hideTabBar(_ shouldHide: Bool) {
            calledHideTabBar = true
        }
    }
}
