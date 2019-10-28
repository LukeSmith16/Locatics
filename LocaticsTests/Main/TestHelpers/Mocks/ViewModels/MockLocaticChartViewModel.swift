//
//  MockLocaticChartViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticChartViewModel: LocaticChartViewModelInterface {
    var locaticChartDataEntries: [LocaticChartDataEntryInterface] = [MockLocaticChartDataEntry()]

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"

        return dateFormatter
    }

    func dataEntriesCount() -> Int {
        return locaticChartDataEntries.count
    }
}
