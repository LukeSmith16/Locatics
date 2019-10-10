//
//  MockPermissionsManager.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreLocation

@testable import Locatics

class MockLocationPermissionsManager: LocationPermissionsManagerInterface {

    var calledHasAuthorizedLocationPermissions = false
    var calledAuthorizeLocationPermissions = false
    var calledAuthorizationStatus = false

    var authorizePermsState: CLAuthorizationStatus = .authorizedAlways

    weak var delegate: LocationPermissionsManagerDelegate?

    func hasAuthorizedLocationPermissions() -> Bool {
        calledHasAuthorizedLocationPermissions = true
        return authorizePermsState == .authorizedAlways
    }

    func authorizeLocationPermissions() {
        calledAuthorizeLocationPermissions = true
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        calledAuthorizationStatus = true
        return authorizePermsState
    }
}
