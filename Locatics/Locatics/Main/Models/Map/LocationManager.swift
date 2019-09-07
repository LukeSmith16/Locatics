//
//  LocationManager.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

enum LocationError: Error {
    case locationNotFound

    var localizedDescription: String {
        switch self {
        case .locationNotFound:
            return "Your location could not be determined."
        }
    }
}

protocol LocationManagerInterface: class {
    var locationDelegate: LocationManagerDelegate? { get set }
    func findCurrentLocation(completion: @escaping (Result<LocationData, LocationError>) -> Void)
}

protocol LocationManagerDelegate: class {
    func userDidEnterNewRegion(_ locationName: String)
}

class LocationManager: NSObject, LocationManagerInterface {
    weak var locationDelegate: LocationManagerDelegate?
    var locationProvider: LocationProviderInterface

    private var findCurrentLocationCompletion: (Result<LocationData, LocationError>) -> Void

    init(locationProvider: LocationProviderInterface) {
        self.locationProvider = locationProvider
        self.findCurrentLocationCompletion = { (result) in }

        super.init()

        self.locationProvider.delegate = self
    }

    func findCurrentLocation(completion: @escaping (Result<LocationData, LocationError>) -> Void) {
        self.findCurrentLocationCompletion = completion
        locationProvider.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            findCurrentLocationCompletion(.failure(.locationNotFound))
            return
        }

        findCurrentLocationCompletion(.success(lastLocation))
    }
}
