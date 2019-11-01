//
//  MockLocaticCellViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticCellViewModel: LocaticCellViewModelInterface {
    var locatic: LocaticData {
        return MockLocatic()
    }

    var hoursSpentThisWeek: String! = "10"

    var locaticChartViewModel: LocaticChartViewModelInterface! {
        return MockLocaticChartViewModel()
    }
}
