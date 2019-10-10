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
    func getAllLocatics()
}

protocol LocaticsMapViewModelViewDelegate: AddLocaticMapRadiusAnnotationViewDelegate {
    func zoomToUserLocation(latMeters: Double, lonMeters: Double)
    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double)
    func addLocaticMapAnnotation(_ locatic: LocaticData)
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {
    weak var viewDelegate: LocaticsMapViewModelViewDelegate?
    weak var locationPinCoordinateDelegate: LocaticsMainLocationPinCoordinateDelegate?

    private let locaticStorage: LocaticStorageInterface!
    private var locatics: [LocaticData] = [] {
        didSet {
            for locatic in self.locatics {
                self.viewDelegate?.addLocaticMapAnnotation(locatic)
            }
        }
    }

    init(locaticStorage: LocaticStorageInterface) {
        self.locaticStorage = locaticStorage
    }

    func goToUserRegion() {
        viewDelegate?.zoomToUserLocation(latMeters: 750, lonMeters: 750)
    }

    func updatePinAnnotationRadius(toRadius radius: Double) {
        viewDelegate?.updatePinAnnotationRadius(toRadius: radius)
    }

    func getLocationPinCoordinate() -> Coordinate {
        return locationPinCoordinateDelegate!.getPinCurrentLocationCoordinate()
    }

    func getAllLocatics() {
        locaticStorage.fetchLocatics(predicate: nil, sortDescriptors: nil) { (result) in
            switch result {
            case .success(let success):
                self.locatics = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
