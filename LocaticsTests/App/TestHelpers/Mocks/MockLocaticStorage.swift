//
//  MockLocaticStorage.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

// swiftlint:disable function_parameter_count

@testable import Locatics

class MockLocaticStorage: LocaticStorageInterface {
    var persistentStorageObserver = MulticastDelegate<LocaticPersistentStorageDelegate>()

    func fetchLocatics(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void) {

    }

    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double) {

    }

    func updateLocatic(locatic: LocaticData,
                       name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping (StorageManagerError?) -> Void) {

    }

    func deleteLocatic(_ locatic: LocaticData,
                       completion: @escaping (StorageManagerError?) -> Void) {

    }
}
