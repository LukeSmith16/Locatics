//
//  InMemoryCDStack.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

public func mockPersistentContainer() -> NSPersistentContainer {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

    let container = NSPersistentContainer(name: "LocaticsDatabase", managedObjectModel: managedObjectModel)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false

    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
        precondition(description.type == NSInMemoryStoreType)

        if let error = error {
            fatalError("Creating in-memory coordinator failed \(error)")
        }
    }

    return container
}
