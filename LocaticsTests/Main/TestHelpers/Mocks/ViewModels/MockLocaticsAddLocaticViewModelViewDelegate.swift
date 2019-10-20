//
//  MockLocaticsAddLocaticViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

// swiftlint:disable type_name

@testable import Locatics
class MockLocaticsAddLocaticViewModelViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate {
    var calledShouldHideAddLocaticViews = false
    var calledGetLocationPinCoordinate = false

    func getPinCurrentLocationCoordinate() -> Coordinate {
        calledGetLocationPinCoordinate = true
        return Coordinate(latitude: 25.0, longitude: 20.0)
    }

    var shouldHideValue: Bool?
    func shouldHideAddLocaticViews(_ shouldHide: Bool) {
        calledShouldHideAddLocaticViews = true
        shouldHideValue = shouldHide
    }
}
