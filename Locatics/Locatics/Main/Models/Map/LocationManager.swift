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
    let locationGeocoder: LocationGeocoderInterface
    let locationStorage: LocationStorageInterface

    private var findCurrentLocationCompletion: (Result<LocationData, LocationError>) -> Void

    init(locationProvider: LocationProviderInterface,
         locationGeocoder: LocationGeocoderInterface,
         locationStorage: LocationStorageInterface) {
        self.locationProvider = locationProvider
        self.locationGeocoder = locationGeocoder
        self.locationStorage = locationStorage
        self.findCurrentLocationCompletion = { (result) in }

        super.init()

        setupLocationProvider()
    }

    func findCurrentLocation(completion: @escaping (Result<LocationData, LocationError>) -> Void) {
        findCurrentLocationCompletion = completion
        locationProvider.requestLocation()
    }
}

private extension LocationManager {
    func setupLocationProvider() {
        locationProvider.delegate = self
        locationProvider.allowsBackgroundLocationUpdates = true
        locationProvider.startMonitoringVisits()
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

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let locationFromVisit = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        locationGeocoder.reverseGeocodeLocation(locationFromVisit) { [weak self] (placemarks, error) in
            guard let `self` = self else { return }
            guard let placemark = placemarks?.first, let description = placemark.thoroughfare, error == nil else {
                return
            }

            self.newVisitReceived(visit, description: description)
        }
    }

    func newVisitReceived(_ visit: CLVisit, description: String) {
        let newLocation = VisitedLocation(visit: visit, description: description)
        locationStorage.saveLocationOnDisk(newLocation)
    }
}
