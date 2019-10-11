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
    var calledUserDidEnterLocaticRegion = false
    var calledUserDidLeaveLocaticRegion = false

    var passedRegionIdentifier: String?

    func locationPermissionsNotAuthorised() {
        calledLocationPermissionsNotAuthorised = true
    }

    func userDidEnterLocaticRegion(regionIdentifier: String) {
        calledUserDidEnterLocaticRegion = true
        passedRegionIdentifier = regionIdentifier
    }

    func userDidLeaveLocaticRegion(regionIdentifier: String) {
        calledUserDidLeaveLocaticRegion = true
        passedRegionIdentifier = regionIdentifier
    }
}
