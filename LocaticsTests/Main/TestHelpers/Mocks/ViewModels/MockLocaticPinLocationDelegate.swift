//
//  MockLocaticPinLocationDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticPinLocationDelegate: LocaticPinLocationDelegate {
    var calledGetPinCurrentLocationCoordinate = false
    var calledUpdatePinRadius = false

    func getPinCurrentLocationCoordinate() -> Coordinate {
        calledGetPinCurrentLocationCoordinate = true
        return Coordinate(latitude: 25.0, longitude: 51.5)
    }

    var newRadius: Double?
    func updatePinAnnotationRadius(toRadius radius: Double) {
        calledUpdatePinRadius = true
        newRadius = radius
    }
}
