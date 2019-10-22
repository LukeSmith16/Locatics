//
//  LocaticsModuleFactory.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticsModuleFactoryInterface: class {
    func createLocaticsListModule() -> LocaticsListViewController
}

class LocaticsModuleFactory: LocaticsModuleFactoryInterface {
    private let storageManager: StorageManagerInterface
    private let locaticStorage: LocaticStorageInterface

    init(storageManager: StorageManagerInterface,
         locaticStorage: LocaticStorageInterface) {
        self.storageManager = storageManager
        self.locaticStorage = locaticStorage
    }

    func createLocaticsListModule() -> LocaticsListViewController {
        let locaticsListModule = LocaticsListViewController()
        locaticsListModule.locaticsViewModel = createLocaticsViewModel()

        return locaticsListModule
    }
}

private extension LocaticsModuleFactory {
    func createLocaticsViewModel() -> LocaticsViewModelInterface {
        let locaticsCollectionViewModel = createLocaticsCollectionViewModel()
        return LocaticsViewModel(locaticsCollectionViewModel: locaticsCollectionViewModel)
    }

    func createLocaticsCollectionViewModel() -> LocaticsCollectionViewModelInterface {
        return LocaticsCollectionViewModel()
    }
}
