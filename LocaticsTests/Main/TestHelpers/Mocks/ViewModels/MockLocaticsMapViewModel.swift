//
//  MockLocaticsMapViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsMapViewModel: LocaticsMapViewModelInterface {
    var calledGoToUserRegion = false
    var calledUpdatePinAnnotationRadius = false
    var calledGetLocationPinCoordinate = false
    var calledGetAllLocatics = false

    weak var viewDelegate: LocaticsMapViewModelViewDelegate?

    var coordinate = Coordinate(latitude: 50, longitude: 25)

    func goToUserRegion() {
        calledGoToUserRegion = true
    }

    var updatePinAnnotationRadiusPassedValue: Double?
    func updatePinAnnotationRadius(toRadius radius: Double) {
        updatePinAnnotationRadiusPassedValue = radius
        calledUpdatePinAnnotationRadius = true
    }

    func getLocationPinCoordinate() -> Coordinate {
        calledGetLocationPinCoordinate = true
        return coordinate
    }

    func getAllLocatics() {
        calledGetAllLocatics = true
    }
}
