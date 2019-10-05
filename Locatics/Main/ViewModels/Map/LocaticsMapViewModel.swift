//
//  LocaticsMapViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LocaticsMapViewModelInterface: class {
    var viewDelegate: LocaticsMapViewModelViewDelegate? {get set}
    var addLocaticViewDelegate: LocaticsMapAddLocaticViewModelViewDelegate? {get set}

    var addLocaticViewModel: AddLocaticViewModelInterface? {get}

    func getMainTitle() -> String
    func getSubtitle() -> String

    func getUserRegion()
    func addLocaticWasTapped()
    func closeLocaticCardViewWasTapped()
}

protocol LocaticsMapAddLocaticViewModelViewDelegate: class {
    func shouldHideAddLocaticViews(_ shouldHide: Bool)
    func getLocationPinCoordinate() -> Coordinate
    func updateLocationMarkerRadiusConstraint(withNewConstant constant: CGFloat)
}

protocol LocaticsMapViewModelViewDelegate: class {
    func setNavigationTitle(_ title: String)
    func showAlert(title: String, message: String)
    func zoomToUserLocation(latMeters: Double, lonMeters: Double)
    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double)
    func hideTabBar(_ shouldHide: Bool)
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {

    weak var viewDelegate: LocaticsMapViewModelViewDelegate?
    weak var addLocaticViewDelegate: LocaticsMapAddLocaticViewModelViewDelegate?

    var addLocaticViewModel: AddLocaticViewModelInterface?

    var locationManager: LocationManagerInterface? {
        didSet {
            locationManager?.locationDelegate = self
        }
    }

    func getMainTitle() -> String {
        guard let lastVisitedLocation = locationManager?.lastVisitedLocation else {
            setCurrentLocationName()
            return "Fetching location..."
        }

        return lastVisitedLocation.description
    }

    func getSubtitle() -> String {
        guard let lastVisitedLocation = locationManager?.lastVisitedLocation else {
            return "Just now"
        }

        let formattedArrivalDate = DateFormatterManager.hoursMinutes(from: lastVisitedLocation.date)
        return "Since " + formattedArrivalDate
    }

    func getUserRegion() {
        locationManager?.findCurrentLocation(completion: { [unowned self] (result) in
            switch result {
            case .success(let success):
                self.viewDelegate?.updateMapRegion(location: success.coordinate, latMeters: 10000, lonMeters: 10000)
            case .failure(let failure):
                self.viewDelegate?.showAlert(title: "Error", message: failure.localizedDescription)
            }
        })
    }

    func addLocaticWasTapped() {
        viewDelegate?.zoomToUserLocation(latMeters: 200,
                                         lonMeters: 200)

        addLocaticViewDelegate?.shouldHideAddLocaticViews(false)
        viewDelegate?.hideTabBar(true)
    }

    func closeLocaticCardViewWasTapped() {
        closeAddLocaticCardView()
    }
}

private extension LocaticsMapViewModel {
    func setCurrentLocationName() {
        locationManager?.findCurrentLocation(completion: { [unowned self] (result) in
            switch result {
            case .success(let success):
                self.viewDelegate?.setNavigationTitle(success.description)
            case .failure(let failure):
                self.viewDelegate?.showAlert(title: "Error", message: failure.localizedDescription)
            }
        })
    }
}

extension LocaticsMapViewModel: LocationManagerDelegate {
    func locationPermissionsNotAuthorised() {
        viewDelegate?.showAlert(title: "Permissions Not Authorised",
                                message: "Please enable permissions by going to the apps settings")
    }
}

extension LocaticsMapViewModel: LocaticPinLocationDelegate {
    func getPinCurrentLocationCoordinate() -> Coordinate {
        return addLocaticViewDelegate!.getLocationPinCoordinate()
    }

    func updatePinRadius(toRadius radius: Float) {
        addLocaticViewDelegate?.updateLocationMarkerRadiusConstraint(withNewConstant: CGFloat(radius))
    }
}

extension LocaticsMapViewModel: LocaticEntryValidationDelegate {
    func validationErrorOccured(_ error: String) {
        viewDelegate?.showAlert(title: "Error adding Locatic", message: error)
    }

    func closeAddLocaticCardView() {
        addLocaticViewDelegate?.shouldHideAddLocaticViews(true)
        viewDelegate?.hideTabBar(false)
    }
}
