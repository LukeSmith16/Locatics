//
//  CoreDataStack.swift
//  Locatics
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

func createApplicationPersistenceContainer(completion: @escaping (NSPersistentContainer) -> Void) {
    let container = NSPersistentContainer(name: "LocaticsDatabase")
    container.loadPersistentStores {_, error in
        guard error == nil else {
            fatalError("Failed to load store: \(error!.localizedDescription)")
        }

        completion(container)
    }
}
