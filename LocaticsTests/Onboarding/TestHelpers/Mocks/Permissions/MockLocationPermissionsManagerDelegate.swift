//
//  MockLocationPermissionsManagerDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
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
