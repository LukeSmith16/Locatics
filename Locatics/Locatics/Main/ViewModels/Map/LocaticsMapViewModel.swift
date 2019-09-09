//
//  LocaticsMapViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticsMapViewModelInterface: class {
    func getMainTitle() -> String
    func getSubtitle() -> String
}

class LocaticsMapViewModel: LocaticsMapViewModelInterface {

    private(set) var locationManager: LocationManagerInterface

    init(locationManager: LocationManagerInterface) {
        self.locationManager = locationManager
        self.locationManager.locationDelegate = self
    }

    func getMainTitle() -> String {
        return ""
    }

    func getSubtitle() -> String {
        return ""
    }
}

extension LocaticsMapViewModel: LocationManagerDelegate {
    func locationPermissionsNotAuthorised() {

    }
}
