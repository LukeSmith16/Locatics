//
//  LocaticsMapViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol AddLocaticMapRadiusAnnotationViewDelegate: class {
    func updatePinAnnotationRadius(toRadius radius: Double)
}

protocol LocaticsMapViewModelInterface: AddLocaticMapRadiusAnnotationViewDelegate {
    var viewDelegate: LocaticsMapViewModelViewDelegate? {get set}

    func goToUserRegion()
    func getLocationPinCoordinate() -> Coordinate
}

protocol LocaticsMapViewModelViewDelegate: AddLocaticMapRadiusAnnotationViewDelegate {
    func zoomToUserLocation(latMeters: Double, lonMeters: Double)
    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double)
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {
    weak var viewDelegate: LocaticsMapViewModelViewDelegate?
    weak var locationPinCoordinateDelegate: LocaticsMainLocationPinCoordinateDelegate?

    func goToUserRegion() {
        viewDelegate?.zoomToUserLocation(latMeters: 2000, lonMeters: 2000)
    }

    func updatePinAnnotationRadius(toRadius radius: Double) {
        viewDelegate?.updatePinAnnotationRadius(toRadius: radius)
    }

    func getLocationPinCoordinate() -> Coordinate {
        return locationPinCoordinateDelegate!.getPinCurrentLocationCoordinate()
    }
}
