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
    func createLocaticsListModule() -> LocaticsListViewController {
        return LocaticsListViewController()
    }
}
