//
//  LocaticsMainViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

// swiftlint:disable identifier_name

@testable import Locatics
class LocaticsMainViewModelTests: XCTestCase {

    var sut: LocaticsMainViewModel!

    private var mockLocaticsViewModelViewObserver: MockLocaticsMainViewModelViewDelegate!
    private var mockLocaticsViewModelAddLocaticViewObserver: MockLocaticsAddLocaticViewModelViewDelegate!
    private var mockLocaticsMapViewModel: MockLocaticsMapViewModel!
    private var mockLocationManager: MockLocationManager!

    private var mockLocaticStorage: MockLocaticStorage!

    override func setUp() {
        mockLocaticsViewModelViewObserver = MockLocaticsMainViewModelViewDelegate()
        mockLocaticsViewModelAddLocaticViewObserver = MockLocaticsAddLocaticViewModelViewDelegate()
        mockLocaticsMapViewModel = MockLocaticsMapViewModel()
        mockLocationManager = MockLocationManager()

        mockLocaticStorage = MockLocaticStorage()

        sut = LocaticsMainViewModel()
        sut.viewDelegate = mockLocaticsViewModelViewObserver
        sut.addLocaticViewDelegate = mockLocaticsViewModelAddLocaticViewObserver
        sut.locaticsMapViewModel = mockLocaticsMapViewModel
        sut.locationManager = mockLocationManager

        sut.locaticStorage = mockLocaticStorage
    }

    override func tearDown() {
        mockLocaticsViewModelViewObserver = nil
        mockLocaticsViewModelAddLocaticViewObserver = nil
        mockLocaticsMapViewModel = nil
        mockLocationManager = nil
        mockLocaticStorage = nil
        sut = nil
        super.tearDown()
    }

    func test_locationManager_isNotNil() {
        XCTAssertNotNil(sut.locationManager)
        XCTAssertNotNil(sut.locationManager!.locationDelegate)
    }

    func test_getRecentLocation_callsFindCurrentLocation() {
        mockLocationManager.locationBlockLocationValue = VisitedLocation(
        CLLocationCoordinate2D(latitude: 25.0, longitude: 30.0),
        date: Date(),
        description: "test title")

        sut.getRecentLocation()

        XCTAssertTrue(mockLocationManager.calledFindCurrentLocation)
    }

    func test_getRecentLocation_callsSetNavigationTitleView() {
        mockLocationManager.locationBlockLocationValue = VisitedLocation(
        CLLocationCoordinate2D(latitude: 25.0, longitude: 30.0),
        date: Date(),
        description: "test title")

        sut.getRecentLocation()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledSetNavigationTitleView)
    }

    func test_getRecentLocation_returnsCurrentLocationData() {
        mockLocationManager.locationBlockLocationValue = VisitedLocation(
        CLLocationCoordinate2D(latitude: 25.0, longitude: 30.0),
        date: Date(),
        description: "test title")

        sut.getRecentLocation()

        let passedNavigationSubtitle = mockLocaticsViewModelViewObserver.passedNavigationSubtitle!
        let arrivalDateFormatted = DateFormatterManager.hoursMinutes(from: Date())

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedNavigationTitle!, "Test Title")
        XCTAssertTrue(passedNavigationSubtitle == "SINCE " + arrivalDateFormatted.uppercased())
    }

    func test_getRecentLocation_callsViewDelegateIfErrorOccurs() {
        mockLocationManager.lastVisitedLocation = nil
        mockLocationManager.locationBlockErrorValue = .locationNotFound

        sut.getRecentLocation()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)
    }

    func test_getRecentLocation_returnsJustNowForSubtitleIfLastVisitedLocationIsNil() {
        mockLocationManager.locationBlockLocationValue = VisitedLocation(
        CLLocationCoordinate2D(latitude: 25.0, longitude: 30.0),
        date: Date(),
        description: "test title")

        mockLocationManager.lastVisitedLocation = nil
        mockLocationManager.locationBlockErrorValue = .locationNotFound

        sut.getRecentLocation()

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedNavigationSubtitle!, "JUST NOW")
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

    func test_addLocaticWasTapped_callsGoToUserRegionForced() {
        sut.addLocaticWasTapped()

        XCTAssertTrue(mockLocaticsMapViewModel.passedGoToUserRegionForce!)
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

    func test_calledShouldHideAddLocaticViews_whenCloseAddLocaticCardView() {
        sut.closeAddLocaticCardView()

        XCTAssertTrue(mockLocaticsViewModelAddLocaticViewObserver.shouldHideValue!)
    }

    func test_updatePinAnnotationRadius_callsMapViewModelPassingRadius() {
        sut.updatePinAnnotationRadius(toRadius: 30)

        XCTAssertTrue(mockLocaticsMapViewModel.calledUpdatePinAnnotationRadius)
        XCTAssertEqual(mockLocaticsMapViewModel.updatePinAnnotationRadiusPassedValue!,
                       30)
    }

    func test_showAlert_callsViewDelegateShowAlert() {
        sut.showAlert(title: "", message: "")

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)
    }

    func test_showAlert_passesViewDelegateShowAlertValues() {
        sut.showAlert(title: "MyTitle", message: "MyMessage")

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedTitle!, "MyTitle")
        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedMessage!, "MyMessage")
    }

    func test_locaticWasInserted_callsStartMonitoringRegion() {
        let locatic = MockLocatic()
        sut.locaticWasInserted(locatic)

        XCTAssertTrue(mockLocationManager.calledStartMonitoringRegion)
    }

    func test_locaticWasInserted_passesInsertedLocaticToLocationManager() {
        let locatic = MockLocatic()
        locatic.identity = 50

        sut.locaticWasInserted(locatic)

        XCTAssertEqual(mockLocationManager.passedMonitoringRegionForLocatic!.identity,
                       locatic.identity)
    }

    func test_locaticWasUpdated_callsStopMonitoringForRegionAndStartMonitoringForRegion() {
        let locatic = MockLocatic()
        sut.locaticWasUpdated(locatic)

        XCTAssertTrue(mockLocationManager.calledStopMonitoringRegion)
        XCTAssertTrue(mockLocationManager.calledStartMonitoringRegion)
    }

    func test_locaticWasDeleted_callsStopMonitoringForRegion() {
        let locatic = MockLocatic()
        sut.locaticWasDeleted(locatic)

        XCTAssertTrue(mockLocationManager.calledStopMonitoringRegion)
    }

    func test_locaticWasDeleted_passesDeletedLocaticToLocationManager() {
        let locatic = MockLocatic()
        locatic.identity = 50

        sut.locaticWasDeleted(locatic)

        XCTAssertEqual(mockLocationManager.passedMonitoringRegionForLocatic!.identity,
                       locatic.identity)
    }
}
