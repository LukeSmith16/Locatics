//
//  LocaticStorage.swift
//  Locatics
//
//  Created by Luke Smith on 28/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

// swiftlint:disable function_parameter_count

protocol LocaticPersistentStorageDelegate: class {
    func locaticWasInserted(_ insertedLocatic: LocaticData)
    func locaticWasUpdated(_ updatedLocatic: LocaticData)
    func locaticWasDeleted(_ deletedLocatic: LocaticData)
}

protocol LocaticStorageInterface {
    var persistentStorageObserver: MulticastDelegate<LocaticPersistentStorageDelegate> {get set}

    func fetchLocatics(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void)
    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double)
    func updateLocatic(locatic: LocaticData,
                       name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping (StorageManagerError?) -> Void)
    func deleteLocatic(_ locatic: LocaticData,
                       completion: @escaping (StorageManagerError?) -> Void)
}

class LocaticStorage: LocaticStorageInterface {
    private let storageManager: StorageManagerInterface

    var persistentStorageObserver = MulticastDelegate<LocaticPersistentStorageDelegate>()

    init(storageManager: StorageManagerInterface) {
        self.storageManager = storageManager
    }

    func fetchLocatics(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void) {
        storageManager.fetchObjects(entity: Locatic.self,
                                    predicate: predicate,
                                    sortDescriptors: sortDescriptors) { (result) in
                                        switch result {
                                        case .success(let success):
                                            completion(.success(success))
                                        case .failure(let failure):
                                            completion(.failure(failure))
                                        }
        }
    }

    // TODO: This COULD possibly throw an error. Add logic for it.
    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double) {
        var values: [String: Any] = [:]
        values["name"] = name
        values["radius"] = radius
        values["longitude"] = longitude
        values["latitude"] = latitude

        storageManager.createObject(entity: Locatic.self, values: values) { [weak self] (newLocatic) in
            self?.handleInsertionOfLocatic(newLocatic)
        }
    }

    func updateLocatic(locatic: LocaticData,
                       name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping (StorageManagerError?) -> Void) {
        var changedValues: [String: Any] = [:]
        changedValues["name"] = name
        changedValues["radius"] = radius
        changedValues["longitude"] = longitude
        changedValues["latitude"] = latitude

        storageManager.updateObject(entity: Locatic.self,
                                    identity: locatic.identity,
                                    updatedValues: changedValues) { [weak self] (result) in
                                        switch result {
                                        case .success(let success):
                                            self?.handleUpdateOfLocatic(success)
                                            completion(nil)
                                        case .failure(let failure):
                                            completion(failure)
                                        }
        }
    }

    func deleteLocatic(_ locatic: LocaticData, completion: @escaping (StorageManagerError?) -> Void) {
        storageManager.deleteObject(entity: Locatic.self, identity: locatic.identity) { [weak self] (error) in
            guard error == nil else {
                return completion(error)
            }

            self?.handleDeletionOfLocatic(locatic)
            completion(nil)
        }
    }
}

private extension LocaticStorage {
    func handleInsertionOfLocatic(_ newLocatic: LocaticData) {
        self.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasInserted(newLocatic)
        }
    }

    func handleUpdateOfLocatic(_ updatedLocatic: LocaticData) {
        self.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasUpdated(updatedLocatic)
        }
    }

    func handleDeletionOfLocatic(_ deletedLocatic: LocaticData) {
        self.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasDeleted(deletedLocatic)
        }
    }
}
