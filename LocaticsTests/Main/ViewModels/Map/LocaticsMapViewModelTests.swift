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
    private var mockLocaticsViewModelAddLocaticViewObserver: MockLocaticsAddLocaticViewModelViewDelegate!
    private var mockLocationManager: MockLocationManager!

    override func setUp() {
        mockLocaticsViewModelViewObserver = MockLocaticsMapViewModelViewDelegate()
        mockLocaticsViewModelAddLocaticViewObserver = MockLocaticsAddLocaticViewModelViewDelegate()
        mockLocationManager = MockLocationManager()

        sut = LocaticsMapViewModel()
        sut.viewDelegate = mockLocaticsViewModelViewObserver
        sut.addLocaticViewDelegate = mockLocaticsViewModelAddLocaticViewObserver
        sut.locationManager = mockLocationManager
    }

    override func tearDown() {
        mockLocaticsViewModelViewObserver = nil
        mockLocaticsViewModelAddLocaticViewObserver = nil
        mockLocationManager = nil
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

    func test_addLocaticWasTapped_showsAddLocaticCardViewWithPassedValues() {
        sut.addLocaticWasTapped()

        XCTAssertEqual(mockLocaticsViewModelViewObserver.latMeter, 200)
        XCTAssertEqual(mockLocaticsViewModelViewObserver.lonMeter, 200)
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

    func test_getPinCurrentLocationCoordinate_returnsVCMapViewCenterCoordinate() {
        let pinLocationCoordinate = sut.getPinCurrentLocationCoordinate()

        XCTAssertTrue(mockLocaticsViewModelAddLocaticViewObserver.calledGetLocationPinCoordinate)

        XCTAssertEqual(pinLocationCoordinate.latitude,
                       mockLocaticsViewModelAddLocaticViewObserver.getLocationPinCoordinate().latitude)
        XCTAssertEqual(pinLocationCoordinate.longitude,
                       mockLocaticsViewModelAddLocaticViewObserver.getLocationPinCoordinate().longitude)
    }

    func test_updateLocationMarkerRadiusConstraint_callsAddLocaticViewDelegateUpdateLocationPinRadius() {
        sut.updatePinRadius(toRadius: 5)
        XCTAssertTrue(mockLocaticsViewModelAddLocaticViewObserver.calledUpdateLocationMarkerRadiusConstraint)
    }

    func test_updateLocationMarkerRadiusConstraint_passesRadiusToAddLocaticViewDelegateUpdateLocationPinRadius() {
        sut.updatePinRadius(toRadius: 5.0)
        XCTAssertEqual(mockLocaticsViewModelAddLocaticViewObserver.newConstant!,
                       5)
    }

    func test_closeLocaticCardViewWasTapped_callsCloseAddLocaticCardView() {
        sut.closeLocaticCardViewWasTapped()

        XCTAssertTrue(mockLocaticsViewModelAddLocaticViewObserver.shouldHideValue!)
    }

    func test_closeLocaticCardViewWasTapped_callsHideTabBar() {
        sut.closeLocaticCardViewWasTapped()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledHideTabBar)
    }

    func test_calledShouldHideAddLocaticViews_whenCloseAddLocaticCardView() {
        sut.closeAddLocaticCardView()

        XCTAssertTrue(mockLocaticsViewModelAddLocaticViewObserver.shouldHideValue!)
    }

    func test_calledShouldHideAddLocaticViews_whenAddLocaticWasTapped() {
        sut.addLocaticWasTapped()

        XCTAssertFalse(mockLocaticsViewModelAddLocaticViewObserver.shouldHideValue!)
    }
}

private extension LocaticsMapViewModelTests {
    class MockLocaticsMapViewModelViewDelegate: LocaticsMapViewModelViewDelegate {
        var calledSetNavigationTitle = false
        var calledShowAlert = false
        var calledUpdateMapRegion = false
        var calledZoomToUserLocation = false
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

        func hideTabBar(_ shouldHide: Bool) {
            calledHideTabBar = true
        }
    }

    class MockLocaticsAddLocaticViewModelViewDelegate: LocaticsMapAddLocaticViewModelViewDelegate {
        var calledShowAddLocaticCardView = false
        var calledAddLocaticCardView = false

        var calledGetLocationPinCoordinate = false
        var calledShowLocationMarkerPin = false
        var calledUpdateLocationMarkerRadiusConstraint = false
        var calledShouldHideAddLocaticViews = false

        func showAddLocaticCardView() {
            calledAddLocaticCardView = true
        }

        func showLocationMarkerPin() {
            calledShowLocationMarkerPin = true
        }

        func getLocationPinCoordinate() -> Coordinate {
            calledGetLocationPinCoordinate = true
            return Coordinate(latitude: 25.0, longitude: 20.0)
        }

        var newConstant: CGFloat?
        func updateLocationMarkerRadiusConstraint(withNewConstant constant: CGFloat) {
            calledUpdateLocationMarkerRadiusConstraint = true
            newConstant = constant
        }

        var shouldHideValue: Bool?
        func shouldHideAddLocaticViews(_ shouldHide: Bool) {
            calledShouldHideAddLocaticViews = true
            shouldHideValue = shouldHide
        }
    }
}
