//
//  StorageManager.swift
//  Locatics
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

protocol StorageManagerInterface: class {
    func createObject<Object: DB_LocalItem>(entity: Object.Type,
                                            values: [String: Any],
                                            completion: @escaping (Object) -> Void)
    func fetchObject<Object: DB_LocalItem>(entity: Object.Type,
                                           identity: Int64,
                                           completion: @escaping (Object?) -> Void)
    func fetchObjects<Object: DB_LocalItem>(entity: Object.Type,
                                            predicate: NSPredicate?,
                                            sortDescriptors: [NSSortDescriptor]?,
                                            completion: @escaping (Result<[Object], StorageManagerError>) -> Void)
    func updateObject<Object: DB_LocalItem>(entity: Object.Type,
                                            identity: Int64,
                                            updatedValues: [String: Any],
                                            completion: @escaping (Result<Object, StorageManagerError>) -> Void)
    func deleteObject<Object: DB_LocalItem>(entity: Object.Type,
                                            identity: Int64,
                                            completion: @escaping (StorageManagerError?) -> Void)
}

enum StorageManagerError: Error {
    case couldNotFindObject
    case badRequest
}

extension StorageManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .couldNotFindObject:
            return "Could not find object matching ID."
        case .badRequest:
            return "Bad fetch request formed."
        }
    }
}

class StorageManager: StorageManagerInterface {
    private let psc: NSPersistentContainer
    private let moc: NSManagedObjectContext

    init(psc: NSPersistentContainer) {
        self.psc = psc
        self.moc = psc.viewContext
    }

    func createObject<Object: DB_LocalItem>(entity: Object.Type,
                                            values: [String: Any],
                                            completion: @escaping (Object) -> Void) {
        moc.performChanges { [unowned self] in
            let newObject = entity.init(context: self.moc)
            newObject.identity = Int64(UUID().uuidString.hashValue)
            newObject.setValuesForKeys(values)

            completion(newObject)
        }
    }

    func fetchObject<Object: DB_LocalItem>(entity: Object.Type,
                                           identity: Int64,
                                           completion: @escaping (Object?) -> Void) {
        let fetchedObject = fetchObject(moc: moc, entity: entity, identity: identity)
        completion(fetchedObject)
    }

    func fetchObjects<Object: DB_LocalItem>(entity: Object.Type,
                                            predicate: NSPredicate?,
                                            sortDescriptors: [NSSortDescriptor]?,
                                            completion: @escaping (Result<[Object], StorageManagerError>) -> Void) {
        psc.performBackgroundTask { (context) in
            let fetchRequest = Object.sortedFetchRequest
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors

            do {
                let fetchResults = try context.fetch(fetchRequest)
                completion(.success(fetchResults))
            } catch {
                completion(.failure(.badRequest))
            }
        }
    }

    func updateObject<Object: DB_LocalItem>(entity: Object.Type,
                                            identity: Int64,
                                            updatedValues: [String: Any],
                                            completion: @escaping (Result<Object, StorageManagerError>) -> Void) {
        guard let objectToUpdate = fetchObject(moc: moc, entity: entity, identity: identity) else {
            completion(.failure(.couldNotFindObject))
            return
        }

        moc.performChanges {
            objectToUpdate.setValuesForKeys(updatedValues)
            completion(.success(objectToUpdate))
        }
    }

    func deleteObject<Object: DB_LocalItem>(entity: Object.Type,
                                            identity: Int64,
                                            completion: @escaping (StorageManagerError?) -> Void) {
        guard let objectToDelete = fetchObject(moc: moc, entity: entity, identity: identity) else {
            completion(.couldNotFindObject)
            return
        }

        moc.performChanges {
            self.moc.delete(objectToDelete)
            completion(nil)
        }
    }
}

private extension StorageManager {
    func fetchObject<Object: DB_LocalItem>(moc: NSManagedObjectContext,
                                           entity: Object.Type,
                                           identity: Int64) -> Object? {
        let fetchRequest = Object.sortedFetchRequest
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(DB_LocalItem.identity)) == %ld", identity)

        let fetchObjectsMatchingID = try? moc.fetch(fetchRequest)
        return fetchObjectsMatchingID?.first
    }
}
