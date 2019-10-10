//
//  MockLocationManagerDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocationManagerDelegate: LocationManagerDelegate {
    var calledLocationPermissionsNotAuthorised = false

    func locationPermissionsNotAuthorised() {
        calledLocationPermissionsNotAuthorised = true
    }
}
