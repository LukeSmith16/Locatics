//
//  MockLocaticsMainLocationPinCoordinateDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

// swiftlint:disable type_name

@testable import Locatics
class MockLocaticsMainLocationPinCoordinateDelegate: LocaticsMainLocationPinCoordinateDelegate {
    var calledGetPinCurrentLocationCoordinate = false

    func getPinCurrentLocationCoordinate() -> Coordinate {
        calledGetPinCurrentLocationCoordinate = true
        return Coordinate(latitude: 10, longitude: 7)
    }
}
