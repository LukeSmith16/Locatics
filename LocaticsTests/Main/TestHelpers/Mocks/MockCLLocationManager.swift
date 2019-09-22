//
//  MockCLLocationManager.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

@testable import Locatics

struct MockLocation: LocationData {
    var coordinate: Coordinate {
        return Coordinate(latitude: 51.509865, longitude: -0.118092)
    }
}

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

class MockCLVisit: CLVisit, Codable {
    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 25.0, longitude: 50.0)
    }

    override var arrivalDate: Date {
        return Date()
    }
}
