//
//  MockLocationProvider.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

@testable import Locatics

class MockLocationProvider: LocationProviderInterface {
    weak var delegate: CLLocationManagerDelegate?
    var allowsBackgroundLocationUpdates: Bool = false

    var calledRequestLocation = false
    var calledStartMonitoringVisits = false

    func requestLocation() {
        calledRequestLocation = true
    }

    func startMonitoringVisits() {
        calledStartMonitoringVisits = true
    }
}
