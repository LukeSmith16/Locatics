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

    var sut: LocationPermissionsManager!

    override func setUp() {
        sut = LocationPermissionsManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_locationManager_isNotNil() {
        XCTAssertNotNil(sut.locationManager)
    }

    func test_didChangeAuthAlways_callsPermissionsGranted() {
        let mockLocationPermissionsManagerDelegate = MockLocationPermissionsManagerDelegate()
        sut.delegate = mockLocationPermissionsManagerDelegate

        sut.locationManager(sut.locationManager, didChangeAuthorization: .authorizedAlways)

        XCTAssertTrue(mockLocationPermissionsManagerDelegate.calledPermissionsGranted)
    }

    func test_didChangeAuthDenied_callsPermissionsDenied() {
        let mockLocationPermissionsManagerDelegate = MockLocationPermissionsManagerDelegate()
        sut.delegate = mockLocationPermissionsManagerDelegate

        sut.locationManager(sut.locationManager, didChangeAuthorization: .denied)

        XCTAssertTrue(mockLocationPermissionsManagerDelegate.calledPermissionsDenied)
    }
}
