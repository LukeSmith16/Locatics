//
//  Locatic.swift
//  Locatics
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

protocol LocaticData {
    var identity: Int64 {get}

    var name: String {get}
    var radius: Float {get}
    var longitude: Double {get}
    var latitude: Double {get}
    var iconPath: String {get}
}

@objc(Locatic)
class Locatic: DB_LocalItem, LocaticData {
    @NSManaged public var name: String
    @NSManaged public var radius: Float
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var iconPath: String
}
