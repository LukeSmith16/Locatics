//
//  LocaticChartDataEntry.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticChartDataEntryInterface {
    var entryDate: Date {get}
    var entryValue: Double? {get}
}

struct LocaticChartDataEntry: LocaticChartDataEntryInterface {
    private(set) var entryDate: Date
    private(set) var entryValue: Double?
}
