//
//  MockLocaticsMapViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsMapViewModelViewDelegate: LocaticsMapViewModelViewDelegate {

    var calledZoomToUserLocation = false
    var calledUpdateMapRegion = false
    var calledUpdatePinAnnotationRadius = false
    var calledAddLocaticMapAnnotationCount = 0
    var calledRemoveLocaticMapAnnotation = false

    var passedCoordinate: Coordinate?
    var passedLatMeters: Double?
    var passedLonMeters: Double?

    func zoomToUserLocation(latMeters: Double, lonMeters: Double) {
        calledZoomToUserLocation = true
        passedLatMeters = latMeters
        passedLonMeters = lonMeters
    }

    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double) {
        calledUpdateMapRegion = true
        passedCoordinate = location
        passedLatMeters = latMeters
        passedLonMeters = lonMeters
    }

    var updatePinAnnotationRadiusPassedRadius: Double?
    func updatePinAnnotationRadius(toRadius radius: Double) {
        calledUpdatePinAnnotationRadius = true
        updatePinAnnotationRadiusPassedRadius = radius
    }

    var passedLocatic: LocaticData?
    func addLocaticMapAnnotation(_ locatic: LocaticData) {
        passedLocatic = locatic
        calledAddLocaticMapAnnotationCount += 1
    }

    func removeLocaticMapAnnotation(at coordinate: Coordinate) {
        passedCoordinate = coordinate
        calledRemoveLocaticMapAnnotation = true
    }
}
