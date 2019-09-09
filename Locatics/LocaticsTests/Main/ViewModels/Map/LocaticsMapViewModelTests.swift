//
//  LocaticsMapViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsMapViewModelTests: XCTestCase {

    private var mockLocationManager: MockLocationManager!
    var sut: LocaticsMapViewModel!

    override func setUp() {
        mockLocationManager = MockLocationManager()
        sut = LocaticsMapViewModel(locationManager: mockLocationManager)
    }

    override func tearDown() {
        mockLocationManager = nil
        sut = nil
        super.tearDown()
    }

    func test_locationManager_isNotNil() {
        XCTAssertNotNil(sut.locationManager.locationDelegate)
    }

    func test_mainTitle_returnsLastVisitedLocationTitle() {

    }

    func test_subtitle_returnsLastVisitedLocationArrivalDate() {

    }
}
