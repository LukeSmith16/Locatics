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

    var localizedDescription: String {
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

    func findCurrentLocation(completion: @escaping (Result<String, LocationError>) -> Void)
}

protocol LocationManagerDelegate: class {
    func locationPermissionsNotAuthorised()
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

    var lastVisitedLocation: VisitedLocationData? {
        return locationStorage.lastVisitedLocation
    }

    private var findCurrentLocationCompletion: (Result<String, LocationError>) -> Void

    init(locationProvider: LocationProviderInterface,
         locationGeocoder: LocationGeocoderInterface,
         locationStorage: LocationStorageInterface,
         locationPermissions: LocationPermissionsManagerInterface) {
        self.locationProvider = locationProvider
        self.locationGeocoder = locationGeocoder
        self.locationStorage = locationStorage
        self.locationPermissions = locationPermissions
        self.findCurrentLocationCompletion = { (result) in }

        super.init()
    }

    func findCurrentLocation(completion: @escaping (Result<String, LocationError>) -> Void) {
        guard isLocationPermissionsAuthorised() else {
            completion(.failure(.notAuthorised))
            return
        }

        findCurrentLocationCompletion = completion
        locationProvider.requestLocation()
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

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            findCurrentLocationCompletion(.failure(.locationNotFound))
            return
        }

        DELETETHIS("DidUpdateLocations (Ignore)")
        reverseGeocodeLocation(lastLocation) { [unowned self] (result) in
            self.findCurrentLocationCompletion(result)
        }
    }

    // TODO: Implement error handling (via delegate?)
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        DELETETHIS()

        let locationFromVisit = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        reverseGeocodeLocation(locationFromVisit) { (result) in
            switch result {
            case .success(let success):
                self.newVisitReceived(visit, description: success)
            case .failure(let failure):
                self.DELETETHIS("DIDVISIT was called but fail on geocode")
                print(failure.localizedDescription)
            }
        }
    }

    func DELETETHIS(_ message: String = "LOCATICS") {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }

        let content = UNMutableNotificationContent()

        content.title = message
        content.body = "Location visit monitoring got triggered"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false))

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func newVisitReceived(_ visit: CLVisit, description: String) {
        DELETETHIS()

        let newLocation = VisitedLocation(visit: visit, description: description)
        locationStorage.saveLocationOnDisk(newLocation)
    }

    // TODO: Handle this... (was crashing at times for some reason)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DELETETHIS(error.localizedDescription)
        print(error.localizedDescription)
    }
}
