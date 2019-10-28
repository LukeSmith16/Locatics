//
//  MockLocaticChartDataEntry.swift
//  LocaticsTests
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticChartDataEntry: LocaticChartDataEntryInterface {
    var entryDate: Date {
        return Date()
    }

    var entryValue: Double? {
        return 10.0
    }
}
