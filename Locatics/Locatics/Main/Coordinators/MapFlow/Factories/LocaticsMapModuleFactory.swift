//
//  LocaticsMapModuleFactory.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocaticsMapModuleFactoryInterface: class {
    func createLocaticsMapModule() -> LocaticsMapViewController
}

class LocaticsMapModuleFactory: LocaticsMapModuleFactoryInterface {
    func createLocaticsMapModule() -> LocaticsMapViewController {
        let locaticsMapModule = LocaticsMapViewController()
        locaticsMapModule.locaticsMapViewModel = createLocaticsMapViewModel()

        return locaticsMapModule
    }
}

private extension LocaticsMapModuleFactory {
    func createLocaticsMapViewModel() -> LocaticsMapViewModelInterface {
        let locationManager = createLocationManager()
        let locaticsMapViewModel = LocaticsMapViewModel(locationManager: locationManager)
        return locaticsMapViewModel
    }

    func createLocationManager() -> LocationManagerInterface {
        let locationStorage = createLocationStorage()
        let locationManager = LocationManager(locationProvider: CLLocationManager(),
                                              locationGeocoder: CLGeocoder(),
                                              locationStorage: locationStorage,
                                              locationPermissions: LocationPermissionsManager())

        return locationManager
    }

    func createLocationStorage() -> LocationStorageInterface {
        let locationStorage = LocationStorage(appFileSystem: AppFileSystem())
        return locationStorage
    }
}
