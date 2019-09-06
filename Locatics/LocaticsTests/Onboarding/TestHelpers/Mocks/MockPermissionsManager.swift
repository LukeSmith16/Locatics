//
//  MockPermissionsManager.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics

class MockLocationPermissionsManager: LocationPermissionsManagerInterface {

    var calledHasAuthorizedLocationPermissions = false
    var calledAuthorizeLocationPermissions = false

    var authorizePermsState = false

    weak var delegate: LocationPermissionsManagerDelegate?

    func hasAuthorizedLocationPermissions() -> Bool {
        calledHasAuthorizedLocationPermissions = true
        return authorizePermsState
    }

    func authorizeLocationPermissions() {
        calledAuthorizeLocationPermissions = true
    }
}

class MockLocationPermissionsManagerDelegate: LocationPermissionsManagerDelegate {
    var calledPermissionsGranted = false
    var calledPermissionsDenied = false

    func permissionsGranted() {
        calledPermissionsGranted = true
    }

    func permissionsDenied() {
        calledPermissionsDenied = true
    }
}
