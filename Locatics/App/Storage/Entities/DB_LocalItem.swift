//
//  DB_LocalItem.swift
//  Locatics
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable type_name

import CoreData

enum DB_LocalItemMappingKey: String {
    case identity
}

@objc(DB_LocalItem)
class DB_LocalItem: NSManagedObject {
    @NSManaged public var identity: Int64
}

extension DB_LocalItem: Managed {}
