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

    var changedPredicate: NSPredicate?
    var returnLocatics: [MockLocatic]?
    func fetchLocatics(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void) {
        calledFetchLocatics = true
        changedPredicate = predicate

        if shouldFail {
            completion(.failure(.badRequest))
        } else {
            if returnLocatics != nil {
                completion(.success(returnLocatics!))
            } else {
                completion(.success([MockLocatic(), MockLocatic()]))
            }
        }
    }

    var changedName: String?
    var changedRadius: Float?
    var changedLongitude: Double?
    var changedLatitude: Double?
    var changedIconPath: String?
    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       iconPath: String,
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
        changedIconPath = iconPath
    }

    func updateLocatic(locatic: LocaticData,
                       name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       iconPath: String,
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
