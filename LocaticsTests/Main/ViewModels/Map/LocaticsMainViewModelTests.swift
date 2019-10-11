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
    private var mockLocaticVisitStorage: MockLocaticVisitStorage!

    override func setUp() {
        mockLocaticsViewModelViewObserver = MockLocaticsMainViewModelViewDelegate()
        mockLocaticsViewModelAddLocaticViewObserver = MockLocaticsAddLocaticViewModelViewDelegate()
        mockLocaticsMapViewModel = MockLocaticsMapViewModel()
        mockLocationManager = MockLocationManager()

        mockLocaticStorage = MockLocaticStorage()
        mockLocaticVisitStorage = MockLocaticVisitStorage()

        sut = LocaticsMainViewModel()
        sut.viewDelegate = mockLocaticsViewModelViewObserver
        sut.addLocaticViewDelegate = mockLocaticsViewModelAddLocaticViewObserver
        sut.locaticsMapViewModel = mockLocaticsMapViewModel
        sut.locationManager = mockLocationManager

        sut.locaticStorage = mockLocaticStorage
        sut.locaticVisitStorage = mockLocaticVisitStorage
    }

    override func tearDown() {
        mockLocaticsViewModelViewObserver = nil
        mockLocaticsViewModelAddLocaticViewObserver = nil
        mockLocaticsMapViewModel = nil
        mockLocationManager = nil
        mockLocaticStorage = nil
        mockLocaticVisitStorage = nil
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

    func test_closeLocaticCardViewWasTapped_callsHideTabBar() {
        sut.closeLocaticCardViewWasTapped()

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledHideTabBar)
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

    func test_userDidEnterLocaticRegion_callsFetchLocaticsWithPredicateForRegionIdentifier() {
        let locatic = MockLocatic()
        sut.userDidEnterLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticStorage.calledFetchLocatics)
        XCTAssertEqual(mockLocaticStorage.changedPredicate!.predicateFormat,
                       "name == \"\(locatic.name)\"")
    }

    func test_userDidEnterLocaticRegion_onFailCallsShowAlert() {
        mockLocaticStorage.shouldFail = true

        let locatic = MockLocatic()
        sut.userDidEnterLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedTitle!,
                       "Error fetching Locatic")
        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedMessage!,
                       "Bad fetch request formed.")
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

    func test_userDidEnterLocaticRegion_onFailShowsAlert() {
        mockLocaticVisitStorage.shouldFail = true

        sut.userDidEnterLocaticRegion(regionIdentifier: "TestLocatic")

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedTitle!,
                       "Error entering Locatic region")
        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedMessage!,
                       "Could not find object matching ID.")
    }

    func test_userDidLeaveLocaticRegion_callsFetchLocaticsWithPredicateForRegionIdentifier() {
        let locatic = MockLocatic()
        sut.userDidLeaveLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticStorage.calledFetchLocatics)
        XCTAssertEqual(mockLocaticStorage.changedPredicate!.predicateFormat,
                       "name == \"\(locatic.name)\"")
    }

    func test_userDidLeaveLocaticRegion_onFailCallsShowAlert() {
        mockLocaticStorage.shouldFail = true

        let locatic = MockLocatic()
        sut.userDidLeaveLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedTitle!,
                       "Error fetching Locatic")
        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedMessage!,
                       "Bad fetch request formed.")
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

    func test_userDidLeaveLocaticRegion_onFailShowsAlert() {
        mockLocaticVisitStorage.shouldFail = true

        let locatic = MockLocatic()
        sut.userDidLeaveLocaticRegion(regionIdentifier: locatic.name)

        XCTAssertTrue(mockLocaticsViewModelViewObserver.calledShowAlert)

        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedTitle!,
                       "Error leaving Locatic region")
        XCTAssertEqual(mockLocaticsViewModelViewObserver.passedMessage!,
                       "Could not find object matching ID.")
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
