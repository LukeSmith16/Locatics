//
//  LocationManager.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

import UserNotifications

enum LocationError: Error {
    case locationNotFound
    case notAuthorised
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return "Your location could not be determined."
        case .notAuthorised:
            return "You have not enabled loction permissions."
        }
    }
}

protocol LocationManagerInterface: class {
    var locationDelegate: LocationManagerDelegate? { get set }
    var lastVisitedLocation: VisitedLocationData? { get }

    func findCurrentLocation(completion: @escaping (Result<VisitedLocationData, LocationError>) -> Void)

    func startMonitoringRegion(for locatic: LocaticData)
    func stopMonitoringRegion(for locatic: LocaticData)
}

protocol LocationManagerDelegate: class {
    func locationPermissionsNotAuthorised()

    func userDidEnterLocaticRegion(regionIdentifier: String)
    func userDidLeaveLocaticRegion(regionIdentifier: String)
}

class LocationManager: NSObject, LocationManagerInterface {
    weak var locationDelegate: LocationManagerDelegate? {
        didSet {
            setupLocationProvider()
        }
    }

    var locationProvider: LocationProviderInterface
    let locationGeocoder: LocationGeocoderInterface
    let locationStorage: LocationStorageInterface
    let locationPermissions: LocationPermissionsManagerInterface

    var lastVisitedLocation: VisitedLocationData?

    private var findCurrentLocationCompletion: (Result<VisitedLocationData, LocationError>) -> Void

    init(locationProvider: LocationProviderInterface,
         locationGeocoder: LocationGeocoderInterface,
         locationStorage: LocationStorageInterface,
         locationPermissions: LocationPermissionsManagerInterface) {
        self.locationProvider = locationProvider
        self.locationGeocoder = locationGeocoder
        self.locationStorage = locationStorage
        self.locationPermissions = locationPermissions
        self.findCurrentLocationCompletion = { (result) in }
        self.lastVisitedLocation = locationStorage.lastVisitedLocation

        super.init()
    }

    func findCurrentLocation(completion: @escaping (Result<VisitedLocationData, LocationError>) -> Void) {
        guard isLocationPermissionsAuthorised() else {
            completion(.failure(.notAuthorised))
            return
        }

        findCurrentLocationCompletion = completion
        locationProvider.requestLocation()
    }

    func startMonitoringRegion(for locatic: LocaticData) {
        let coordinate = Coordinate(latitude: locatic.latitude,
                                    longitude: locatic.longitude)

        let circularRegion = CLCircularRegion(center: coordinate,
                                              radius: Double(locatic.radius),
                                              identifier: locatic.name)
        circularRegion.notifyOnEntry = true
        circularRegion.notifyOnExit = true

        locationProvider.startMonitoring(for: circularRegion)
    }

    func stopMonitoringRegion(for locatic: LocaticData) {
        let regionMatchingLocatic = locationProvider.monitoredRegions.first { (region) -> Bool in
            return region.identifier == locatic.name
        }

        if let stopMonitoringRegion = regionMatchingLocatic {
            locationProvider.stopMonitoring(for: stopMonitoringRegion)
        }
    }
}

private extension LocationManager {
    func setupLocationProvider() {
        guard isLocationPermissionsAuthorised() else {
            locationDelegate?.locationPermissionsNotAuthorised()
            return
        }

        locationProvider.delegate = self
        locationProvider.allowsBackgroundLocationUpdates = true
        locationProvider.startMonitoringVisits()
    }

    func isLocationPermissionsAuthorised() -> Bool {
        return locationPermissions.hasAuthorizedLocationPermissions()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            findCurrentLocationCompletion(.failure(.locationNotFound))
            return
        }

        handleDidUpdateLocation(lastLocation)
    }

    // TODO: Implement error handling (via delegate?)
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let locationFromVisit = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        reverseGeocodeLocation(locationFromVisit) { (result) in
            switch result {
            case .success(let success):
                self.newVisitReceived(visit, description: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func newVisitReceived(_ visit: CLVisit, description: String) {
        let newLocation = VisitedLocation(visit: visit, description: description)
        locationStorage.saveLocationOnDisk(newLocation)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLCircularRegion else { return }
        locationDelegate?.userDidEnterLocaticRegion(regionIdentifier: region.identifier)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLCircularRegion else { return }
        locationDelegate?.userDidLeaveLocaticRegion(regionIdentifier: region.identifier)
    }

    // TODO: Handle this... (was crashing at times for some reason)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LocationManager {
    func handleDidUpdateLocation(_ location: CLLocation) {
        reverseGeocodeLocation(location) { [unowned self] (result) in
            switch result {
            case .success(let success):
                let visitedLocation = VisitedLocation(location.coordinate,
                                                      date: Date(),
                                                      description: success)

                self.lastVisitedLocation = visitedLocation
                self.findCurrentLocationCompletion(.success(visitedLocation))
            case .failure(let failure):
                self.findCurrentLocationCompletion(.failure(failure))
            }
        }
    }

    func reverseGeocodeLocation(_ location: CLLocation, completion: @escaping (Result<String, LocationError>) -> Void) {
        locationGeocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, let description = placemark.thoroughfare, error == nil else {
                completion(.failure(.locationNotFound))
                return
            }

            completion(.success(description))
        }
    }
}
