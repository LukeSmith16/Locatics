//
//  MockLocatic.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocatic: LocaticData {
    var identity: Int64 = 0

    var name: String = "TestLocatic"
    var radius: Float = 50 // Meters
    var longitude: Double = 12.0
    var latitude: Double = 10.0
    var iconPath: String = "locaticIcon"

    var locaticVisits: NSOrderedSet? = NSOrderedSet(array: [MockLocaticVisit()])
}
