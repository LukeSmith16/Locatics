//
//  CoreLocation+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

protocol LocationData {
    var coordinate: Coordinate { get }
}

extension CLLocation: LocationData {}

protocol LocationProviderInterface {
    var delegate: CLLocationManagerDelegate? {get set}
    var allowsBackgroundLocationUpdates: Bool {get set}

    var monitoredRegions: Set<CLRegion> {get}

    func requestLocation()
    func startMonitoringVisits()

    func startMonitoring(for region: CLRegion)
    func stopMonitoring(for region: CLRegion)
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
