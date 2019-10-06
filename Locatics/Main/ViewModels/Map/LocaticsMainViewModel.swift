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

    func getMainTitle() -> String
    func getSubtitle() -> String

    func addLocaticWasTapped()
    func closeLocaticCardViewWasTapped()
}

protocol LocaticsMainLocationPinCoordinateDelegate: class {
    func getPinCurrentLocationCoordinate() -> Coordinate
}

protocol LocaticsMainAddLocaticViewModelViewDelegate: LocaticsMainLocationPinCoordinateDelegate {
    func shouldHideAddLocaticViews(_ shouldHide: Bool)
}

protocol LocaticsMainViewModelViewDelegate: class {
    func setNavigationTitle(_ title: String)
    func showAlert(title: String, message: String)
    func hideTabBar(_ shouldHide: Bool)
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

    func addLocaticWasTapped() {
        locaticsMapViewModel?.goToUserRegion()
        addLocaticViewDelegate?.shouldHideAddLocaticViews(false)
        viewDelegate?.hideTabBar(true)
    }

    func closeLocaticCardViewWasTapped() {
        closeAddLocaticCardView()
    }
}

private extension LocaticsMainViewModel {
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

extension LocaticsMainViewModel: LocationManagerDelegate {
    func locationPermissionsNotAuthorised() {
        viewDelegate?.showAlert(title: "Permissions Not Authorised",
                                message: "Please enable permissions by going to the apps settings")
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
        viewDelegate?.hideTabBar(false)
    }
}
