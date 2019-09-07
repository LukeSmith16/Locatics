//
//  LocaticsMapModuleFactory.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

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
        let locaticsMapViewModel = LocaticsMapViewModel()
        return locaticsMapViewModel
    }
}
