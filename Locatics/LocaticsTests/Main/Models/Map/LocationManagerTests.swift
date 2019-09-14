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
        mockLocationPermissionsManager = MockLocationPermissionsManager()
        mockLocationPermissionsManager.authorizePermsState = .authorizedAlways

        mockLocationStorage = MockLocationStorage()
        mockLocationStorage.lastVisitedLocation = VisitedLocation(
            CLLocationCoordinate2D(latitude: 20.0, longitude: 20.0),
            date: Date(),
            description: "Description")

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
                XCTFail("\(location)")
            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
        }

        XCTAssertTrue(mockLocationProvider.calledRequestLocation)
    }

    func test_delegate_isNotNil() {
        XCTAssertNotNil(sut.locationProvider.delegate)
    }

    func test_didUpdateLocations_callsCompletionBlockWithErrorWhenInvalid() {
        sut.findCurrentLocation { (result) in
            switch result {
            case .success(let location):
                XCTFail("Shouldn't be returning location when error occurs - \(location)")
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

        XCTAssertTrue(mockLocationGeocoder.calledReverseGeocodeLocation)
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
                XCTFail("Should not be getting location if not authorised - \(success)")
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
        guard let sutVisitedLocation = sut.lastVisitedLocation as? VisitedLocation,
            let mockLastVisitedLocation = mockLocationStorage.lastVisitedLocation as? VisitedLocation else {
            XCTFail("Should be convertible to 'VisitedLocation'")
            return
        }

        XCTAssertTrue(sutVisitedLocation === mockLastVisitedLocation)
    }

    func test_didUpdateLocations_callsReverseGeocodeLocation() {
        let givenLocation = CLLocation(latitude: 10.0, longitude: 10.0)

        sut.locationManager(CLLocationManager(), didUpdateLocations: [givenLocation])

        XCTAssertTrue(mockLocationGeocoder.calledReverseGeocodeLocation)
    }

    func test_didUpdateLocations_failsWhenNoLocationsPassed() {
        sut.locationManager(CLLocationManager(), didUpdateLocations: [])

        XCTAssertFalse(mockLocationGeocoder.calledReverseGeocodeLocation)
    }

    func test_handleDidUpdateLocation_setsLastVisitedLocationAndCallsFindCurrentLocationCompletion() {
        let mockLocation = MockLocation()
        let location = CLLocation(latitude: mockLocation.coordinate.latitude,
                                  longitude: mockLocation.coordinate.longitude)
        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

        sut.handleDidUpdateLocation(location)

        guard let visitedLocation = sut.lastVisitedLocation else {
            XCTFail("LastVisitedLocation should not be nil")
            return
        }

        XCTAssertTrue(mockLocationGeocoder.calledReverseGeocodeLocation)
        XCTAssertEqual(visitedLocation.coordinate.latitude,
                       mockLocation.coordinate.latitude)
        XCTAssertEqual(visitedLocation.coordinate.longitude,
                       mockLocation.coordinate.longitude)
    }

    func test_handleDidUpdateLocation_failsWhenLocationIsInvalid() {
        mockLocationGeocoder.shouldFail = true

        sut.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation()])
        sut.handleDidUpdateLocation(CLLocation())

        guard let visitedLocation = sut.lastVisitedLocation else {
            XCTFail("LastVisitedLocation should not be nil")
            return
        }

        XCTAssertTrue(mockLocationGeocoder.calledReverseGeocodeLocation)
        XCTAssertEqual(visitedLocation.coordinate.latitude,
                       20.0)
        XCTAssertEqual(visitedLocation.coordinate.longitude,
                       20.0)
    }
}

private extension LocationManagerTests {
    class MockLocationManagerDelegate: LocationManagerDelegate {
        var calledLocationPermissionsNotAuthorised = false

        func locationPermissionsNotAuthorised() {
            calledLocationPermissionsNotAuthorised = true
        }
    }

    class MockLocationGeocoder: LocationGeocoderInterface {
        var calledReverseGeocodeLocation = false
        var locationPassed: CLLocation?

        let placemark = MockCLPlacemark()

        var shouldFail = false

        func reverseGeocodeLocation(_ location: CLLocation,
                                    completionHandler: @escaping CLGeocodeCompletionHandler) {
            calledReverseGeocodeLocation = true
            locationPassed = location

            if shouldFail {
                completionHandler(nil, NSError())
            } else {
                completionHandler([placemark], nil)
            }
        }
    }

    class MockLocationStorage: LocationStorageInterface {
        var calledSaveLocationOnDisk = false

        var lastVisitedLocation: VisitedLocationData?

        func saveLocationOnDisk(_ location: VisitedLocation) {
            calledSaveLocationOnDisk = true
        }
    }

    class MockCLPlacemark: CLPlacemark {
        override var thoroughfare: String? {
            return "TestThoroughfare"
        }
    }
}
