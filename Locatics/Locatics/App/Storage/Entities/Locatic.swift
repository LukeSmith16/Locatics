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
}

@objc(Locatic)
class Locatic: DB_LocalItem, LocaticData {}
