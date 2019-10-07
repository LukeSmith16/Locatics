//
//  MockStorageManager.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

// swiftlint:disable line_length

@testable import Locatics

class MockStorageManager: StorageManagerInterface {

    var calledCreateObject = false
    var calledFetchObject = false
    var calledFetchObjects = false
    var calledUpdateObject = false
    var calledDeleteObject = false

    var shouldFail = false

    var passedCreateObjectValues: [String:Any] = [:]
    func createObject<Object>(entity: Object.Type,
                              values: [String: Any],
                              completion: @escaping (Result<Object, StorageManagerError>) -> Void) where Object: DB_LocalItem {
        calledCreateObject = true
        passedCreateObjectValues = values

        if shouldFail {
            completion(.failure(.badRequest))
        } else {
            completion(.success(Object()))
        }
    }

    func fetchObject<Object>(entity: Object.Type,
                             identity: Int64,
                             completion: @escaping (Object?) -> Void) where Object: DB_LocalItem {
        calledFetchObject = true

        if shouldFail {
            completion(nil)
        } else {
            completion(Object())
        }
    }

    func fetchObjects<Object>(entity: Object.Type,
                              predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?,
                              completion: @escaping (Result<[Object], StorageManagerError>) -> Void) where Object: DB_LocalItem {
        calledFetchObjects = true

        if shouldFail {
            completion(.failure(.badRequest))
        } else {
            completion(.success([Object()]))
        }
    }

    var passedUpdateObjectValues: [String: Any] = [:]
    func updateObject<Object>(entity: Object.Type,
                              identity: Int64,
                              updatedValues: [String: Any],
                              completion: @escaping (Result<Object, StorageManagerError>) -> Void) where Object: DB_LocalItem {
        calledUpdateObject = true
        passedUpdateObjectValues = updatedValues

        if shouldFail {
            completion(.failure(.badRequest))
        } else {
            completion(.success(Object()))
        }
    }

    func deleteObject<Object>(entity: Object.Type,
                              identity: Int64,
                              completion: @escaping (StorageManagerError?) -> Void) where Object: DB_LocalItem {
        calledDeleteObject = true

        if shouldFail {
            completion(.badRequest)
        } else {
            completion(nil)
        }
    }
}
