//
//  LocaticsMapViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticsMapViewModelInterface: class {
    var viewDelegate: LocaticsMapViewModelViewDelegate? {get set}
    var addLocaticViewModel: AddLocaticViewModelInterface? {get}

    func getMainTitle() -> String
    func getSubtitle() -> String

    func getUserRegion()
    func addLocaticWasTapped()
}

protocol LocaticsMapViewModelViewDelegate: class {
    func setNavigationTitle(_ title: String)
    func showAlert(title: String, message: String)
    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double)
    func showAddLocaticCardView()
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {
    weak var viewDelegate: LocaticsMapViewModelViewDelegate?

    var locationManager: LocationManagerInterface? {
        didSet {
            locationManager?.locationDelegate = self
        }
    }

    var addLocaticViewModel: AddLocaticViewModelInterface?

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
        guard let lastVisitedLocation = locationManager?.lastVisitedLocation else { return }
        viewDelegate?.updateMapRegion(location: lastVisitedLocation.coordinate,
                                      latMeters: 50,
                                      lonMeters: 50)
        viewDelegate?.showAddLocaticCardView()
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