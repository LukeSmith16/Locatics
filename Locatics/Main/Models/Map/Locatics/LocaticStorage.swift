//
//  LocaticStorage.swift
//  Locatics
//
//  Created by Luke Smith on 28/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticPersistentStorageDelegate: class {
    func locaticWasInserted(_ insertedLocatic: LocaticData)
    func locaticWasUpdated(_ updatedLocatic: LocaticData)
    func locaticWasDeleted(_ deletedLocatic: LocaticData)
}

protocol LocaticStorageInterface {
    var persistentStorageObserver: MulticastDelegate<LocaticPersistentStorageDelegate> {get set}

    func fetchLocatics(completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void)
    func fetchLocatic(withID: Int64, completion: @escaping (LocaticData?) -> Void)
    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping () -> Void)
    func deleteLocatic(identity: Int64, completion: @escaping (StorageManagerError?) -> Void)
}

class LocaticStorage: LocaticStorageInterface {

    typealias LocaticID = Int64

    private let storageManager: StorageManagerInterface
    private let cache = Cache<LocaticID, LocaticData>()

    var persistentStorageObserver = MulticastDelegate<LocaticPersistentStorageDelegate>()

    init(storageManager: StorageManagerInterface) {
        self.storageManager = storageManager
    }

    func fetchLocatics(completion: @escaping (Result<[LocaticData], StorageManagerError>) -> Void) {
        storageManager.fetchObjects(entity: Locatic.self,
                                    predicate: nil,
                                    sortDescriptors: nil) { [weak self] (result) in
            switch result {
            case .success(let success):
                success.forEach({ self?.cache[$0.identity] = $0 })
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    func fetchLocatic(withID: LocaticID, completion: @escaping (LocaticData?) -> Void) {
        if let cachedObject = cache[withID] {
            return completion(cachedObject)
        }

        storageManager.fetchObject(entity: Locatic.self, identity: withID) { (fetchedLocatic) in
            completion(fetchedLocatic)
        }
    }

    func insertLocatic(name: String,
                       radius: Float,
                       longitude: Double,
                       latitude: Double,
                       completion: @escaping () -> Void) {
        var values: [String: Any] = [:]
        values["name"] = name
        values["radius"] = radius
        values["longitude"] = longitude
        values["latitude"] = latitude

        storageManager.createObject(entity: Locatic.self, values: values) { [weak self] (newLocatic) in
            completion()
            self?.handleInsertionOfLocatic(newLocatic)
        }
    }

    func deleteLocatic(identity: Int64, completion: @escaping (StorageManagerError?) -> Void) {
        storageManager.deleteObject(entity: Locatic.self, identity: identity) { [weak self] (error) in
            guard error == nil else {
                return completion(error)
            }

            self?.cache.removeValue(forKey: identity)
        }
    }
}

private extension LocaticStorage {
    func handleInsertionOfLocatic(_ newLocatic: LocaticData) {
        self.cache.insert(newLocatic, forKey: newLocatic.identity)
        self.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasInserted(newLocatic)
        }
    }

    func handleUpdateOfLocatic(_ updatedLocatic: LocaticData) {
        self.cache.removeValue(forKey: updatedLocatic.identity)
        self.cache.insert(updatedLocatic, forKey: updatedLocatic.identity)
        self.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasUpdated(updatedLocatic)
        }
    }

    func handleDeletionOfLocatic(_ deletedLocatic: LocaticData) {
        self.cache.removeValue(forKey: deletedLocatic.identity)
        self.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasDeleted(deletedLocatic)
        }
    }
}
