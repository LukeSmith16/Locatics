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
    var sut: LocationManager!

    override func setUp() {
        mockLocationManagerObserver = MockLocationManagerDelegate()
        mockLocationProvider = MockLocationProvider()

        sut = LocationManager(locationProvider: mockLocationProvider)
        sut.locationDelegate = mockLocationManagerObserver
    }

    override func tearDown() {
        sut = nil
        mockLocationProvider = nil
        mockLocationManagerObserver = nil
        super.tearDown()
    }

    func test_locationError_values() {
        XCTAssertEqual(LocationError.locationNotFound.localizedDescription,
                       "Your location could not be determined.")
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
}

private extension LocationManagerTests {
    class MockLocationManagerDelegate: LocationManagerDelegate {
        var calledUserDidEnterNewRegion = false

        func userDidEnterNewRegion(_ locationName: String) {
            calledUserDidEnterNewRegion = true
        }
    }
}
