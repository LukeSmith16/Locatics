//
//  PermissionsManager.swift
//  Locatics
//
//  Created by Luke Smith on 05/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationPermissionsManagerDelegate: class {
    func permissionsGranted()
    func permissionsDenied()
}

protocol LocationPermissionsManagerInterface {
    var delegate: LocationPermissionsManagerDelegate? {get set}

    func hasAuthorizedLocationPermissions() -> Bool
    func authorizationStatus() -> CLAuthorizationStatus
    func authorizeLocationPermissions()
}

class LocationPermissionsManager: NSObject, LocationPermissionsManagerInterface {
    weak var delegate: LocationPermissionsManagerDelegate?

    private(set) var locationProviderPermissions: LocationProviderPermissionsInterface

    init(locationProviderPermissions: LocationProviderPermissionsInterface = CLLocationManager()) {
        self.locationProviderPermissions = locationProviderPermissions
        super.init()
        self.locationProviderPermissions.delegate = self
    }

    func hasAuthorizedLocationPermissions() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }

    func authorizeLocationPermissions() {
        locationProviderPermissions.requestAlwaysAuthorization()
    }
}

extension LocationPermissionsManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            delegate?.permissionsDenied()
            return
        }

        delegate?.permissionsGranted()
    }
}
