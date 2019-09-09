//
//  CoreLocation+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

protocol LocationData {
    var coordinate: Coordinate { get }
}

extension CLLocation: LocationData {}

protocol LocationProviderInterface {
    var delegate: CLLocationManagerDelegate? {get set}
    var allowsBackgroundLocationUpdates: Bool {get set}

    func requestLocation()
    func startMonitoringVisits()
}

extension CLLocationManager: LocationProviderInterface {}

protocol LocationProviderPermissionsInterface {
    var delegate: CLLocationManagerDelegate? {get set}
    static func authorizationStatus() -> CLAuthorizationStatus
    func requestAlwaysAuthorization()
}

extension CLLocationManager: LocationProviderPermissionsInterface {}

protocol LocationGeocoderInterface {
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler)
}

extension CLGeocoder: LocationGeocoderInterface {}
