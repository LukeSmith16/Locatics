//
//  LocaticVisit.swift
//  Locatics
//
//  Created by Luke Smith on 11/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreData

@objc protocol LocaticVisitData {
    var identity: Int64 {get}

    var entryDate: Date {get}
    var exitDate: Date? {get}

    var locatic: LocaticData {get}
}

@objc(LocaticVisit)
class LocaticVisit: DB_LocalItem, LocaticVisitData {
    @NSManaged public var entryDate: Date
    @NSManaged public var exitDate: Date?

    @NSManaged public var locatic: LocaticData
}
