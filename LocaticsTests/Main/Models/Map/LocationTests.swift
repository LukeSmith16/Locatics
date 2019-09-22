//
//  LocationTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 08/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Locatics
class LocationTests: XCTestCase {

    func test_init_setsCorrectValues() {
        let date = Date()
        let sut = VisitedLocation(CLLocationCoordinate2D(latitude: 25.0, longitude: 18.0),
                                  date: date,
                                  description: "A description")

        XCTAssertEqual(sut.latitude, 25.0)
        XCTAssertEqual(sut.longitude, 18.0)
        XCTAssertEqual(sut.description, "A description")
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.coordinate.latitude, sut.latitude)
        XCTAssertEqual(sut.coordinate.longitude, sut.longitude)
    }
}
