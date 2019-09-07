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

    var locationBlockLocationValue: LocationData?
    var locationBlockErrorValue: LocationError?

    weak var locationDelegate: LocationManagerDelegate?

    func findCurrentLocation(completion: @escaping (Result<LocationData, LocationError>) -> Void) {
        if let locationBlockLocationValue = locationBlockLocationValue {
            completion(.success(locationBlockLocationValue))
        } else {
            completion(.failure(locationBlockErrorValue!))
        }
    }
}

class MockLocationProvider: LocationProviderInterface {
    var delegate: CLLocationManagerDelegate?
    
    var calledRequestLocation = false

    func requestLocation() {
        calledRequestLocation = true
    }
}
