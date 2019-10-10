//
//  MockCLLocationManager.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

@testable import Locatics

class MockLocationManager: LocationManagerInterface {
    var calledFindCurrentLocation = false

    var locationBlockLocationValue: VisitedLocationData?
    var locationBlockErrorValue: LocationError?
    var lastVisitedLocation: VisitedLocationData?

    weak var locationDelegate: LocationManagerDelegate?

    init() {
        self.lastVisitedLocation = VisitedLocation(CLLocationCoordinate2D(latitude: 20.0,
                                                                          longitude: 20.0),
                                                   date: Date(),
                                                   description: "Place name")
    }

    func findCurrentLocation(completion: @escaping (Result<VisitedLocationData, LocationError>) -> Void) {
        calledFindCurrentLocation = true

        if let locationBlockLocationValue = locationBlockLocationValue {
            completion(.success(locationBlockLocationValue))
        } else {
            completion(.failure(locationBlockErrorValue!))
        }
    }
}
