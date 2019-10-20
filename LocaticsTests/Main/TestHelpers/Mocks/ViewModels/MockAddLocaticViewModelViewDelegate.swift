//
//  MockAddLocaticViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockAddLocaticViewModelViewDelegate: AddLocaticViewModelViewDelegate {
    var calledChangeRadiusText = false

    var changeRadiusTextValue: String?
    func changeRadiusText(_ newRadiusText: String) {
        calledChangeRadiusText = true
        changeRadiusTextValue = newRadiusText
    }
}
