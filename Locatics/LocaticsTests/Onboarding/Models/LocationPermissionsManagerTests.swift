//
//  LocationPermissionsManagerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 05/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Locatics
class LocationPermissionsManagerTests: XCTestCase {

    private var mockLocationProviderPermissions: MockLocationProviderPermissions!
    var sut: LocationPermissionsManager!

    override func setUp() {
        mockLocationProviderPermissions = MockLocationProviderPermissions()
        sut = LocationPermissionsManager(locationProviderPermissions: mockLocationProviderPermissions)
    }

    override func tearDown() {
        mockLocationProviderPermissions = nil
        sut = nil
        super.tearDown()
    }

    func test_locationManager_isNotNil() {
        XCTAssertNotNil(sut.locationManager)
    }

    func test_didChangeAuthAlways_callsPermissionsGranted() {
        let mockLocationPermissionsManagerDelegate = MockLocationPermissionsManagerDelegate()
        sut.delegate = mockLocationPermissionsManagerDelegate

        sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedAlways)

        XCTAssertTrue(mockLocationPermissionsManagerDelegate.calledPermissionsGranted)
    }

    func test_didChangeAuthDenied_callsPermissionsDenied() {
        let mockLocationPermissionsManagerDelegate = MockLocationPermissionsManagerDelegate()
        sut.delegate = mockLocationPermissionsManagerDelegate

        sut.locationManager(CLLocationManager(), didChangeAuthorization: .denied)

        XCTAssertTrue(mockLocationPermissionsManagerDelegate.calledPermissionsDenied)
    }

    /// This test needs improving.
    func test_hasAuthorizedLocationPermissions_callsAuthorizationStatus() {
        let status = sut.hasAuthorizedLocationPermissions()

        XCTAssertTrue(status)
    }

    func test_authorizeLocationPermissions_callsRequestAlwaysAuthorization() {
        sut.authorizeLocationPermissions()

        XCTAssertTrue(mockLocationProviderPermissions.calledRequestAlwaysAuthorization)
    }

    func test_authorizationStatus_callsAuthorizationStatus() {
        let status = sut.authorizationStatus()

        XCTAssertTrue(status == .authorizedAlways)
    }
}

private extension LocationPermissionsManagerTests {
    class MockLocationProviderPermissions: LocationProviderPermissionsInterface {
        var calledRequestAlwaysAuthorization = false

        weak var delegate: CLLocationManagerDelegate?

        static func authorizationStatus() -> CLAuthorizationStatus {
            return .authorizedAlways
        }

        func requestAlwaysAuthorization() {
            calledRequestAlwaysAuthorization = true
        }
    }
}
