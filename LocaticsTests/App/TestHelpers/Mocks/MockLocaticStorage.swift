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

    var calledFetchLocatics = false
    var calledInsertLocatic = false
    var calledUpdateLocatic = false
    var calledDeleteLocatic = false

    var shouldFail = false

    func fetchLocatics(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void) {
        calledFetchLocatics = true
        if shouldFail {
            completion(.failure(.badRequest))
        } else {
            completion(.success([]))
        }
    }

    var changedName: String?
    var changedRadius: Float?
    var changedLongitude: Double?
    var changedLatitude: Double?
    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping (StorageManagerError?) -> Void) {
        calledInsertLocatic = true
        if shouldFail {
            completion(.couldNotFindObject)
        } else {
            completion(nil)
        }

        changedName = name
        changedRadius = radius
        changedLongitude = longitude
        changedLatitude = latitude
    }

    func updateLocatic(locatic: LocaticData,
                       name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping (StorageManagerError?) -> Void) {
        calledUpdateLocatic = true
        if shouldFail {
            completion(.badRequest)
        } else {
            completion(nil)
        }
    }

    func deleteLocatic(_ locatic: LocaticData,
                       completion: @escaping (StorageManagerError?) -> Void) {
        calledDeleteLocatic = true
        if shouldFail {
            completion(.couldNotFindObject)
        } else {
            completion(nil)
        }
    }
}
