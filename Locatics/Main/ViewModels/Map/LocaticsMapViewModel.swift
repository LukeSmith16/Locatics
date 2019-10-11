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

    func goToUserRegion(force: Bool)
    func getLocationPinCoordinate() -> Coordinate
    func getAllLocatics()
}

protocol LocaticsMapViewModelViewDelegate: AddLocaticMapRadiusAnnotationViewDelegate {
    func zoomToUserLocation(latMeters: Double, lonMeters: Double)
    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double)
    func addLocaticMapAnnotation(_ locatic: LocaticData)
    func removeLocaticMapAnnotation(at coordinate: Coordinate)
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {
    weak var viewDelegate: LocaticsMapViewModelViewDelegate?
    weak var locationPinCoordinateDelegate: LocaticsMainLocationPinCoordinateDelegate?
    weak var locaticsMainMapViewModelViewDelegate: LocaticsMainMapViewModelViewDelegate?

    let locaticStorage: LocaticStorageInterface!
    var locatics: [LocaticData] = []

    private var didLocateUser: Bool = false

    init(locaticStorage: LocaticStorageInterface) {
        self.locaticStorage = locaticStorage
        locaticStorage.persistentStorageObserver.add(self)
    }

    func goToUserRegion(force: Bool = false) {
        guard !didLocateUser || force else { return }
        viewDelegate?.zoomToUserLocation(latMeters: 750, lonMeters: 750)
        didLocateUser = true
    }

    func updatePinAnnotationRadius(toRadius radius: Double) {
        viewDelegate?.updatePinAnnotationRadius(toRadius: radius)
    }

    func getLocationPinCoordinate() -> Coordinate {
        return locationPinCoordinateDelegate!.getPinCurrentLocationCoordinate()
    }

    func getAllLocatics() {
        locaticStorage.fetchLocatics(predicate: nil, sortDescriptors: nil) { [weak self] (result) in
            guard let `self` = self else { return }

            switch result {
            case .success(let success):
                self.handleDidFetchLocatics(success)
            case .failure(let failure):
                self.locaticsMainMapViewModelViewDelegate?.showAlert(title: "Error fetching Locatics",
                                                                     message: failure.localizedDescription)
            }
        }
    }
}

private extension LocaticsMapViewModel {
    func handleDidFetchLocatics(_ fetchedLocatics: [LocaticData]) {
        self.locatics = fetchedLocatics

        for locatic in locatics {
            self.viewDelegate?.addLocaticMapAnnotation(locatic)
        }
    }
}

extension LocaticsMapViewModel: LocaticPersistentStorageDelegate {
    func locaticWasInserted(_ insertedLocatic: LocaticData) {
        locatics.append(insertedLocatic)
        viewDelegate?.addLocaticMapAnnotation(insertedLocatic)
    }

    func locaticWasUpdated(_ updatedLocatic: LocaticData) {
        let locaticToUpdateIndex = locatics.firstIndex(where: { $0.identity == updatedLocatic.identity })
        if let updateIndex = locaticToUpdateIndex {
            locaticWasDeleted(locatics[updateIndex])

            locatics.insert(updatedLocatic, at: updateIndex)
            viewDelegate?.addLocaticMapAnnotation(updatedLocatic)
        }
    }

    func locaticWasDeleted(_ deletedLocatic: LocaticData) {
        let locaticToRemoveIndex = locatics.firstIndex(where: { $0.identity == deletedLocatic.identity })
        if let removalIndex = locaticToRemoveIndex {
            locatics.remove(at: removalIndex)

            let coordinate = Coordinate(latitude: deletedLocatic.latitude,
                                        longitude: deletedLocatic.longitude)
            viewDelegate?.removeLocaticMapAnnotation(at: coordinate)
        }
    }
}
