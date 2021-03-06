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
    private let locaticVisitStorage: LocaticVisitStorageInterface

    init(storageManager: StorageManagerInterface,
         locaticStorage: LocaticStorageInterface,
         locaticVisitStorage: LocaticVisitStorageInterface) {
        self.storageManager = storageManager
        self.locaticStorage = locaticStorage
        self.locaticVisitStorage = locaticVisitStorage
    }

    func createLocaticsMapModule() -> LocaticsMapViewController {
        let locaticsMapModule = LocaticsMapViewController()
        locaticsMapModule.locaticsMainViewModel = createLocaticsMainViewModel()

        return locaticsMapModule
    }
}

private extension LocaticsMapModuleFactory {
    func createLocaticsMainViewModel() -> LocaticsMainViewModelInterface {
        let locaticsMainViewModel = LocaticsMainViewModel()

        let locationManager = createLocationManager()
        let addLocaticViewModel = createAddLocaticViewModel(withDelegate: locaticsMainViewModel)
        let locaticsMapViewModel = createLocaticsMapViewModel(with: locaticsMainViewModel)

        locaticsMainViewModel.locationManager = locationManager
        locaticsMainViewModel.addLocaticViewModel = addLocaticViewModel
        locaticsMainViewModel.locaticsMapViewModel = locaticsMapViewModel
        locaticsMainViewModel.locaticStorage = locaticStorage

        return locaticsMainViewModel
    }

    func createLocationManager() -> LocationManagerInterface {
        let locationStorage = createLocationStorage()
        let locationManager = LocationManager(locationProvider: CLLocationManager(),
                                              locationGeocoder: CLGeocoder(),
                                              locationStorage: locationStorage,
                                              locationPermissions: LocationPermissionsManager(),
                                              locationRegionManager: LocationRegionManager(locaticStorage: locaticStorage,
                                                                                           locaticVisitStorage: locaticVisitStorage))

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

    func createLocaticsMapViewModel(with locaticsViewModel: LocaticsMainViewModel) -> LocaticsMapViewModelInterface {
        let locaticsMapViewModel = LocaticsMapViewModel(locaticStorage: locaticStorage)
        locaticsMapViewModel.locationPinCoordinateDelegate = locaticsViewModel
        locaticsMapViewModel.locaticsMainMapViewModelViewDelegate = locaticsViewModel

        return locaticsMapViewModel
    }
}
