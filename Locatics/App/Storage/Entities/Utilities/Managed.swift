//
//  ManagedObjectHelpers.swift
//  Locatics
//
//  Created by Luke Smith on 24/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

public protocol Managed: class, NSFetchRequestResult {
    static var entityName: String {get}
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
    static var defaultPredicate: NSPredicate? {get}
}

extension Managed {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }

    public static var defaultPredicate: NSPredicate? {
        return NSPredicate(value: true)
    }

    public static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate

        return request
    }
}

extension Managed where Self: NSManagedObject {
    public static var entityName: String {
        return String(describing: self)
    }
}
