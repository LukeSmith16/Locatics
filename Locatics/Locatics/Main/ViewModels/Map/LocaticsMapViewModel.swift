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

    func getMainTitle() -> String
    func getSubtitle() -> String
}

protocol LocaticsMapViewModelViewDelegate: class {
    func setNavigationTitle(_ title: String)
    func showAlert(title: String, message: String)
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {
    weak var viewDelegate: LocaticsMapViewModelViewDelegate?

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
}

private extension LocaticsMapViewModel {
    func setCurrentLocationName() {
        locationManager?.findCurrentLocation(completion: { [unowned self] (result) in
            switch result {
            case .success(let success):
                self.viewDelegate?.setNavigationTitle(success)
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
