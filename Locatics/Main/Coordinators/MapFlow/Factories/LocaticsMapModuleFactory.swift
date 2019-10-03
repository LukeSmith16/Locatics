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
    private let storageManager: StorageManagerInterface
    private let locaticStorage: LocaticStorageInterface

    init(storageManager: StorageManagerInterface, locaticStorage: LocaticStorageInterface) {
        self.storageManager = storageManager
        self.locaticStorage = locaticStorage
    }

    func createLocaticsMapModule() -> LocaticsMapViewController {
        let locaticsMapModule = LocaticsMapViewController()
        locaticsMapModule.locaticsMapViewModel = createLocaticsMapViewModel()

        return locaticsMapModule
    }
}

private extension LocaticsMapModuleFactory {
    func createLocaticsMapViewModel() -> LocaticsMapViewModelInterface {
        let locaticsMapViewModel = LocaticsMapViewModel()

        let locationManager = createLocationManager()
        let addLocaticViewModel = createAddLocaticViewModel(withDelegate: locaticsMapViewModel)

        locaticsMapViewModel.locationManager = locationManager
        locaticsMapViewModel.addLocaticViewModel = addLocaticViewModel

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

    func createAddLocaticViewModel(withDelegate delegate: LocaticPinLocationDelegate &
        LocaticEntryValidationDelegate) -> AddLocaticViewModelInterface {
        let addLocaticViewModel = AddLocaticViewModel(locaticStorage: locaticStorage)
        addLocaticViewModel.locaticPinLocationDelegate = delegate
        addLocaticViewModel.locaticEntryValidationDelegate = delegate
        return addLocaticViewModel
    }
}
