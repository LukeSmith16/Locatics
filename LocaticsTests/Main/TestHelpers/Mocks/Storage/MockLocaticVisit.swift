//
//  MockLocaticVisit.swift
//  LocaticsTests
//
//  Created by Luke Smith on 11/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticVisit: LocaticVisitData {
    var identity: Int64 = 0
    var entryDate: Date = Date()
    var exitDate: Date?
    
    var locatic: LocaticData {
        return MockLocatic()
    }
}
