//
//  LocaticsMainViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LocaticsMainViewModelInterface: class {
    var viewDelegate: LocaticsMainViewModelViewDelegate? {get set}
    var addLocaticViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate? {get set}

    var addLocaticViewModel: AddLocaticViewModelInterface? {get}
    var locaticsMapViewModel: LocaticsMapViewModelInterface? {get}

    func getRecentLocation()

    func addLocaticWasTapped()
    func closeLocaticCardViewWasTapped()
}

protocol LocaticsMainLocationPinCoordinateDelegate: class {
    func getPinCurrentLocationCoordinate() -> Coordinate
}

protocol LocaticsMainAddLocaticViewModelViewDelegate: LocaticsMainLocationPinCoordinateDelegate {
    func shouldHideAddLocaticViews(_ shouldHide: Bool)
}

protocol LocaticsMainMapViewModelViewDelegate: class {
    func showAlert(title: String, message: String)
}

protocol LocaticsMainViewModelViewDelegate: LocaticsMainMapViewModelViewDelegate {
    func setNavigationTitleView(title: String, subtitle: String)
}

class LocaticsMainViewModel: LocaticsMainViewModelInterface {
    weak var viewDelegate: LocaticsMainViewModelViewDelegate?
    weak var addLocaticViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate?

    var addLocaticViewModel: AddLocaticViewModelInterface?
    var locaticsMapViewModel: LocaticsMapViewModelInterface?

    var locationManager: LocationManagerInterface? {
        didSet {
            locationManager?.locationDelegate = self
        }
    }

    var locaticStorage: LocaticStorageInterface? {
        didSet {
            locaticStorage?.persistentStorageObserver.add(self)
        }
    }

    func getRecentLocation() {
        getRecentLocationData()
    }

    func addLocaticWasTapped() {
        locaticsMapViewModel?.goToUserRegion(force: true)
        addLocaticViewDelegate?.shouldHideAddLocaticViews(false)
    }

    func closeLocaticCardViewWasTapped() {
        closeAddLocaticCardView()
    }
}

private extension LocaticsMainViewModel {
    func getRecentLocationData() {
        locationManager?.findCurrentLocation(completion: { [unowned self] (result) in
            switch result {
            case .success(let success):
                self.setNavigationTitleView(with: success)
            case .failure(let failure):
                self.viewDelegate?.showAlert(title: "Error", message: failure.localizedDescription)
            }
        })
    }

    func setNavigationTitleView(with visitedLocation: VisitedLocationData) {
        guard let lastLocation = locationManager?.lastVisitedLocation else {
            viewDelegate?.setNavigationTitleView(title: visitedLocation.description.capitalized,
                                                 subtitle: "JUST NOW")
            return
        }

        let formattedArrivalDate = DateFormatterManager.hoursMinutes(from: lastLocation.date)
        let arrivalTimeAtLocation =  ("Since " + formattedArrivalDate).uppercased()

        viewDelegate?.setNavigationTitleView(title: visitedLocation.description.capitalized,
                                             subtitle: arrivalTimeAtLocation)
    }
}

extension LocaticsMainViewModel: LocationManagerDelegate {
    func locationPermissionsNotAuthorised() {
        viewDelegate?.showAlert(title: "Permissions Not Authorised",
                                message: "Please enable permissions by going to the apps settings")
    }
}

extension LocaticsMainViewModel: LocaticPersistentStorageDelegate {
    func locaticWasInserted(_ insertedLocatic: LocaticData) {
        locationManager?.startMonitoringRegion(for: insertedLocatic)
    }

    func locaticWasUpdated(_ updatedLocatic: LocaticData) {
        // Locatic name will suffice for now as that will be constant (You can't change the name of a Locatic)
        locationManager?.stopMonitoringRegion(for: updatedLocatic)
        locationManager?.startMonitoringRegion(for: updatedLocatic)
    }

    func locaticWasDeleted(_ deletedLocatic: LocaticData) {
        locationManager?.stopMonitoringRegion(for: deletedLocatic)
    }
}

extension LocaticsMainViewModel: LocaticPinLocationDelegate {
    func getPinCurrentLocationCoordinate() -> Coordinate {
        return addLocaticViewDelegate!.getPinCurrentLocationCoordinate()
    }

    func updatePinAnnotationRadius(toRadius radius: Double) {
        locaticsMapViewModel?.updatePinAnnotationRadius(toRadius: radius)
    }
}

extension LocaticsMainViewModel: LocaticEntryValidationDelegate {
    func validationErrorOccured(_ error: String) {
        viewDelegate?.showAlert(title: "Error adding Locatic", message: error)
    }

    func closeAddLocaticCardView() {
        addLocaticViewDelegate?.shouldHideAddLocaticViews(true)
    }
}

extension LocaticsMainViewModel: LocaticsMainMapViewModelViewDelegate {
    func showAlert(title: String, message: String) {
        viewDelegate?.showAlert(title: title, message: message)
    }
}
