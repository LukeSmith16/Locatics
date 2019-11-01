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

    private var mockLocaticStorage: MockLocaticStorage!

    private var mockLocaticsMapViewModelViewObserver: MockLocaticsMapViewModelViewDelegate!
    private var mockLocaticsMainMapViewModelViewObserver: MockLocaticsMainMapViewModelViewDelegate!
    private var mockLocaticsMainLocationPinCoordinateObserver: MockLocaticsMainLocationPinCoordinateDelegate!

    override func setUp() {
        mockLocaticStorage = MockLocaticStorage()
        sut = LocaticsMapViewModel(locaticStorage: mockLocaticStorage)

        mockLocaticsMapViewModelViewObserver = MockLocaticsMapViewModelViewDelegate()
        mockLocaticsMainMapViewModelViewObserver = MockLocaticsMainMapViewModelViewDelegate()
        mockLocaticsMainLocationPinCoordinateObserver = MockLocaticsMainLocationPinCoordinateDelegate()

        sut.viewDelegate = mockLocaticsMapViewModelViewObserver
        sut.locationPinCoordinateDelegate = mockLocaticsMainLocationPinCoordinateObserver
        sut.locaticsMainMapViewModelViewDelegate = mockLocaticsMainMapViewModelViewObserver
    }

    override func tearDown() {
        mockLocaticStorage = nil
        mockLocaticsMapViewModelViewObserver = nil
        mockLocaticsMainMapViewModelViewObserver = nil
        mockLocaticsMainLocationPinCoordinateObserver = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsTo_locaticPersistentStorageObserver() {
        mockLocaticStorage.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasInserted(MockLocatic())

            XCTAssertEqual(sut.locatics.count, 1)
        }
    }

    func test_goToUserRegion_callsZoomToUserLocation() {
        sut.goToUserRegion()

        XCTAssertTrue(mockLocaticsMapViewModelViewObserver.calledZoomToUserLocation)

        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedLatMeters!,
                       500)
        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedLonMeters!,
                       500)
    }

    func test_goToUserRegion_doesNotCallZoomToUserLocationIfDidLocateUser() {
        sut.goToUserRegion()
        mockLocaticsMapViewModelViewObserver.calledZoomToUserLocation = false
        sut.goToUserRegion()

        XCTAssertFalse(mockLocaticsMapViewModelViewObserver.calledZoomToUserLocation)
    }

    func test_goToUserRegion_callsZoomToUserLocationIfForced() {
        sut.goToUserRegion()
        mockLocaticsMapViewModelViewObserver.calledZoomToUserLocation = false
        sut.goToUserRegion(force: true)

        XCTAssertTrue(mockLocaticsMapViewModelViewObserver.calledZoomToUserLocation)
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

    func test_getAllLocatics_callsShowAlertOnFailure() {
        mockLocaticStorage.shouldFail = true
        sut.getAllLocatics()

        XCTAssertTrue(mockLocaticsMainMapViewModelViewObserver.calledShowAlert)
    }

    func test_getAllLocatics_passesShowAlertOnFailureValues() {
        mockLocaticStorage.shouldFail = true
        sut.getAllLocatics()

        XCTAssertEqual(mockLocaticsMainMapViewModelViewObserver.passedAlertTitle!,
                       "Error fetching Locatics")
        XCTAssertEqual(mockLocaticsMainMapViewModelViewObserver.passedAlertMessage!,
                       "Bad fetch request formed.")
    }

    func test_handleDidFetchLocatics_setsLocaticsArray() {
        sut.getAllLocatics()

        XCTAssertEqual(sut.locatics.count, 2)
    }

    func test_handleDidFetchLocatics_callsAddLocaticMapAnnotationForEachLocatic() {
        sut.getAllLocatics()

        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.calledAddLocaticMapAnnotationCount, 2)
    }

    func test_getLocaticIconForCoordinate_returnsLocaticIconIfLocaticsArrayIsEmpty() {
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        let iconPath = sut.getLocaticIconForCoordinate(coordinate)

        XCTAssertEqual(iconPath, "locaticIcon")
    }

    func test_getLocaticIconForCoordinate_returnsIconPathMatchingCoordinate() {
        sut.getAllLocatics()

        // MockLocatic values
        let coordinate = Coordinate(latitude: 10.0, longitude: 12.0)
        let iconPath = sut.getLocaticIconForCoordinate(coordinate)

        XCTAssertEqual(iconPath, "locaticIcon")
    }

    func test_locaticWasInserted_addsLocaticToLocaticsArray() {
        let mockLocatic = MockLocatic()

        sut.locaticWasInserted(mockLocatic)

        XCTAssertEqual(sut.locatics.first!.identity, mockLocatic.identity)
    }

    func test_locaticWasInserted_callsAddLocaticMapAnnotation() {
        let mockLocatic = MockLocatic()

        sut.locaticWasInserted(mockLocatic)

        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.calledAddLocaticMapAnnotationCount,
                       1)
    }

    func test_locaticWasInserted_passesLocaticToAddLocaticMapAnnotation() {
        let mockLocatic = MockLocatic()

        sut.locaticWasInserted(mockLocatic)

        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedLocatic!.identity,
                       mockLocatic.identity)
    }

    func test_locaticWasUpdated_updatesLocaticInsideArray() {
        let oldLocatic = MockLocatic()
        sut.locatics.append(oldLocatic)

        let newLocatic = MockLocatic()
        newLocatic.name = "New Locatic"

        sut.locaticWasUpdated(newLocatic)

        let updatedLocatic = sut.locatics.first!

        XCTAssertEqual(sut.locatics.count, 1)
        XCTAssertEqual(updatedLocatic.name, newLocatic.name)
    }

    func test_locaticWasUpdated_callsRemoveLocaticMapAnnotationAndAddLocaticMapAnnotation() {
        let oldLocatic = MockLocatic()
        sut.locatics.append(oldLocatic)

        let newLocatic = MockLocatic()
        newLocatic.name = "New Locatic"

        sut.locaticWasUpdated(newLocatic)

        XCTAssertTrue(mockLocaticsMapViewModelViewObserver.calledRemoveLocaticMapAnnotation)
        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.calledAddLocaticMapAnnotationCount,
                       1)
    }

    func test_locaticWasDeleted_removesLocaticFromArray() {
        let locatic = MockLocatic()
        sut.locatics.append(locatic)

        sut.locaticWasDeleted(locatic)

        XCTAssertEqual(sut.locatics.count, 0)
    }

    func test_locaticWasDeleted_callsRemoveLocaticAtCoordinate() {
        let locatic = MockLocatic()
        sut.locatics.append(locatic)

        sut.locaticWasDeleted(locatic)

        XCTAssertTrue(mockLocaticsMapViewModelViewObserver.calledRemoveLocaticMapAnnotation)
    }

    func test_locaticWasDeleted_passesCoordinateToRemoveLocaticAtCoordinate() {
        let locatic = MockLocatic()
        sut.locatics.append(locatic)

        sut.locaticWasDeleted(locatic)

        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedCoordinate!.latitude,
                       locatic.latitude)
        XCTAssertEqual(mockLocaticsMapViewModelViewObserver.passedCoordinate!.longitude,
                       locatic.longitude)
    }
}
