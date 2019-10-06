//
//  LocaticsMainViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Locatics
class LocaticsMainViewModelTests: XCTestCase {

    var sut: LocaticsMainViewModel!

    private var mockLocaticsViewModelViewObserver: MockLocaticsMainViewModelViewDelegate!
    private var mockLocaticsViewModelAddLocaticViewObserver: MockLocaticsAddLocaticViewModelViewDelegate!
    private var mockLocaticsMapViewModel: MockLocaticsMapViewModel!
    private var mockLocationManager: MockLocationManager!

    override func setUp() {
        mockLocaticsViewModelViewObserver = MockLocaticsMainViewModelViewDelegate()
        mockLocaticsViewModelAddLocaticViewObserver = MockLocaticsAddLocaticViewModelViewDelegate()
        mockLocaticsMapViewModel = MockLocaticsMapViewModel()
        mockLocationManager = MockLocationManager()

        sut = LocaticsMainViewModel()
        sut.viewDelegate = mockLocaticsViewModelViewObserver
        sut.addLocaticViewDelegate = mockLocaticsViewModelAddLocaticViewObserver
        sut.locaticsMapViewModel = mockLocaticsMapViewModel
        sut.locationManager = mockLocationManager
    }

    override func tearDown() {
        mockLocaticsViewModelViewObserver = nil
        mockLocaticsViewModelAddLocaticViewObserver = nil
        mockLocaticsMapViewModel = nil
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

    func test_addLocaticWasTapped_callsGoToUserRegion() {
        sut.addLocaticWasTapped()

        XCTAssertTrue(mockLocaticsMapViewModel.calledGoToUserRegion)
    }

    func test_addLocaticWasTapped_callsShouldHideLocaticViewsFalse() {
        sut.addLocaticWasTapped()

        XCTAssertTrue(mockLocaticsViewModelAddLocaticViewObserver.calledShouldHideAddLocaticViews)
        XCTAssertFalse(mockLocaticsViewModelAddLocaticViewObserver.shouldHideValue!)
    }

    func test_addLocaticWasTapped_callsHideTabBarTrue() {
        sut.addLocaticWasTapped()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledHideTabBar)
        XCTAssertTrue(mockLocaticsViewModelViewObserver.hideTabBarPassedValue!)
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
                       mockLocaticsViewModelAddLocaticViewObserver.getPinCurrentLocationCoordinate().latitude)
        XCTAssertEqual(pinLocationCoordinate.longitude,
                       mockLocaticsViewModelAddLocaticViewObserver.getPinCurrentLocationCoordinate().longitude)
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
}

private extension LocaticsMainViewModelTests {
    class MockLocaticsMainViewModelViewDelegate: LocaticsMainViewModelViewDelegate {
        var calledSetNavigationTitle = false
        var calledShowAlert = false
        var calledHideTabBar = false

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

        var hideTabBarPassedValue: Bool?
        func hideTabBar(_ shouldHide: Bool) {
            calledHideTabBar = true
            hideTabBarPassedValue = shouldHide
        }
    }

    class MockLocaticsAddLocaticViewModelViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate {
        var calledShouldHideAddLocaticViews = false
        var calledGetLocationPinCoordinate = false

        func getPinCurrentLocationCoordinate() -> Coordinate {
            calledGetLocationPinCoordinate = true
            return Coordinate(latitude: 25.0, longitude: 20.0)
        }

        var shouldHideValue: Bool?
        func shouldHideAddLocaticViews(_ shouldHide: Bool) {
            calledShouldHideAddLocaticViews = true
            shouldHideValue = shouldHide
        }
    }

    class MockLocaticsMapViewModel: LocaticsMapViewModelInterface {
        var calledGoToUserRegion = false
        var calledUpdatePinAnnotationRadius = false

        weak var viewDelegate: LocaticsMapViewModelViewDelegate?
        weak var addLocaticViewDelegate: AddLocaticMapRadiusAnnotationViewDelegate?

        func goToUserRegion() {
            calledGoToUserRegion = true
        }

        var updatePinRadiusPassedRadius: Double?
        func updatePinAnnotationRadius(toRadius radius: Double) {
            calledUpdatePinAnnotationRadius = true
            updatePinRadiusPassedRadius = radius
        }

        func getLocationPinCoordinate() -> Coordinate {
            return Coordinate(latitude: 20, longitude: 20)
        }
    }
}
