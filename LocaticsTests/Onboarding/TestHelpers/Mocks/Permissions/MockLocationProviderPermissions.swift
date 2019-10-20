//
//  MockLocationProviderPermissions.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

@testable import Locatics

class MockLocationProviderPermissions: LocationProviderPermissionsInterface {
    var calledRequestAlwaysAuthorization = false

    weak var delegate: CLLocationManagerDelegate?

    static func authorizationStatus() -> CLAuthorizationStatus {
        return .authorizedAlways
    }

    func requestAlwaysAuthorization() {
        calledRequestAlwaysAuthorization = true
    }
}
