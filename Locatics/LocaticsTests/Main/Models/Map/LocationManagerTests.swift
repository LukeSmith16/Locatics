//
//  LocationManagerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Locatics
class LocationManagerTests: XCTestCase {

    private var mockLocationManagerObserver: MockLocationManagerDelegate!
    private var mockLocationProvider: MockLocationProvider!
    private var mockLocationGeocoder: MockLocationGeocoder!
    private var mockLocationStorage: MockLocationStorage!
    private var mockLocationPermissionsManager: MockLocationPermissionsManager!

    var sut: LocationManager!

    override func setUp() {
        mockLocationManagerObserver = MockLocationManagerDelegate()
        mockLocationProvider = MockLocationProvider()
        mockLocationGeocoder = MockLocationGeocoder()
        mockLocationStorage = MockLocationStorage()
        mockLocationPermissionsManager = MockLocationPermissionsManager()
        mockLocationPermissionsManager.authorizePermsState = .authorizedAlways

        sut = LocationManager(locationProvider: mockLocationProvider,
                              locationGeocoder: mockLocationGeocoder,
                              locationStorage: mockLocationStorage,
                              locationPermissions: mockLocationPermissionsManager)
        sut.locationDelegate = mockLocationManagerObserver
    }

    override func tearDown() {
        sut = nil
        mockLocationProvider = nil
        mockLocationManagerObserver = nil
        mockLocationStorage = nil
        mockLocationPermissionsManager = nil
        super.tearDown()
    }

    func test_locationError_values() {
        XCTAssertEqual(LocationError.locationNotFound.localizedDescription,
                       "Your location could not be determined.")
        XCTAssertEqual(LocationError.notAuthorised.localizedDescription,
                       "You have not enabled loction permissions.")
    }

    func test_locationProvider_allowsBackgroundLocationUpdates() {
        XCTAssertTrue(sut.locationProvider.allowsBackgroundLocationUpdates)
    }

    func test_locationProvider_callsStartMonitoringVisits() {
        XCTAssertTrue(mockLocationProvider.calledStartMonitoringVisits)
    }

    func test_findCurrentLocation_callsRequestLocation() {
        sut.findCurrentLocation { (result) in
            switch result {
            case .success(let location):
                XCTFail("\(location.coordinate)")
            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
        }

        XCTAssertTrue(mockLocationProvider.calledRequestLocation)
    }

    func test_delegate_isNotNil() {
        XCTAssertNotNil(sut.locationProvider.delegate)
    }

    func test_didUpdateLocations_callsCompletionBlockWithLocationWhenValid() {
        let givenLocation = CLLocation(latitude: 50.0, longitude: 25.0)

        sut.findCurrentLocation { (result) in
            switch result {
            case .success(let location):
                XCTAssertEqual(location.coordinate.latitude, givenLocation.coordinate.latitude)
                XCTAssertEqual(location.coordinate.longitude, givenLocation.coordinate.longitude)
            case .failure(let failure):
                XCTFail("Shouldn't be failing when location is found - \(failure.localizedDescription)")
            }
        }

        sut.locationManager(CLLocationManager(), didUpdateLocations: [givenLocation])
    }

    func test_didUpdateLocations_callsCompletionBlockWithErrorWhenInvalid() {
        sut.findCurrentLocation { (result) in
            switch result {
            case .success(let location):
                XCTFail("Shouldn't be returning location when error occurs - \(location.coordinate)")
            case .failure(let failure):
                XCTAssertEqual(failure.localizedDescription,
                               LocationError.locationNotFound.localizedDescription)
            }
        }

        sut.locationManager(CLLocationManager(), didUpdateLocations: [])
    }

    func test_didVisit_callsReverseGeocodeLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 25.0, longitude: 50.0)
        let visit = MockCLVisit()
        sut.locationManager(CLLocationManager(), didVisit: visit)

        XCTAssert(mockLocationGeocoder.calledReverseGeocodeLocation)
        XCTAssertEqual(mockLocationGeocoder.locationPassed!.coordinate.latitude, coordinate.latitude)
        XCTAssertEqual(mockLocationGeocoder.locationPassed!.coordinate.longitude, coordinate.longitude)
    }

    func test_newVisitReceived_callsSaveLocationOnDisk() {
        sut.newVisitReceived(MockCLVisit(), description: "Test")

        XCTAssertTrue(mockLocationStorage.calledSaveLocationOnDisk)
    }

    func test_findCurrentLocation_callsPermsNotAuthorisedDelegateIfNotAuthorised() {
        mockLocationManagerObserver.calledLocationPermissionsNotAuthorised = false
        mockLocationPermissionsManager.authorizePermsState = .denied

        sut.findCurrentLocation { (result) in
            switch result {
            case .success(let success):
                XCTFail("Should not be getting location if not authorised - \(success.coordinate)")
            case .failure(let failure):
                XCTAssertEqual(failure.localizedDescription, "You have not enabled loction permissions.")
            }
        }
    }

    func test_settingLocationDelegate_callsPermsNotAuthorisedIfNotAuthorised() {
        mockLocationManagerObserver.calledLocationPermissionsNotAuthorised = false
        mockLocationPermissionsManager.authorizePermsState = .denied

        sut.locationDelegate = mockLocationManagerObserver

        XCTAssertTrue(mockLocationManagerObserver.calledLocationPermissionsNotAuthorised)
    }

    func test_lastVisitedLocation_returnsLocationStorageLastVisitedLocation() {
        mockLocationStorage.lastVisitedLocation = VisitedLocation(
            CLLocationCoordinate2D(latitude: 20.0, longitude: 20.0),
            date: Date(),
            description: "Description")

        guard let sutVisitedLocation = sut.lastVisitedLocation as? VisitedLocation,
            let mockLastVisitedLocation = mockLocationStorage.lastVisitedLocation as? VisitedLocation else {
            XCTFail("Should be convertible to 'VisitedLocation'")
            return
        }

        XCTAssertTrue(sutVisitedLocation === mockLastVisitedLocation)
    }
}

private extension LocationManagerTests {
    class MockLocationManagerDelegate: LocationManagerDelegate {
        var calledLocationPermissionsNotAuthorised = false

        func locationPermissionsNotAuthorised() {
            calledLocationPermissionsNotAuthorised = true
        }
    }

    class MockLocationGeocoder: CLGeocoder {
        var calledReverseGeocodeLocation = false
        var locationPassed: CLLocation?

        let placemark = CLPlacemark()

        override func reverseGeocodeLocation(_ location: CLLocation,
                                             completionHandler: @escaping CLGeocodeCompletionHandler) {
            calledReverseGeocodeLocation = true
            locationPassed = location

            super.reverseGeocodeLocation(location, completionHandler: completionHandler)
        }
    }

    class MockLocationStorage: LocationStorageInterface {
        var calledSaveLocationOnDisk = false

        var lastVisitedLocation: VisitedLocationData?

        func saveLocationOnDisk(_ location: VisitedLocation) {
            calledSaveLocationOnDisk = true
        }
    }
}
