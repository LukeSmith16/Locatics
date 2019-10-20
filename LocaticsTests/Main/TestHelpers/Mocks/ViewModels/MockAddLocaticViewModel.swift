//
//  MockAddLocaticViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockAddLocaticViewModel: AddLocaticViewModelInterface {
    var calledAddLocaticWasTapped = false
    var calledRadiusDidChange = false
    var calledLocaticIconDidChange = false

    weak var viewDelegate: AddLocaticViewModelViewDelegate?

    var locaticNameValue: String?
    var radiusValue: Float?
    func addLocaticWasTapped(locaticName: String?, radius: Float) {
        calledAddLocaticWasTapped = true
        locaticNameValue = locaticName
        radiusValue = radius
    }

    var radiusDidChangeValue: Float?
    func radiusDidChange(_ newValue: Float) {
        calledRadiusDidChange = true
        radiusDidChangeValue = newValue
    }

    var passedTagValue: Int?
    func locaticIconDidChange(_ tag: Int) {
        passedTagValue = tag
        calledLocaticIconDidChange = true
    }
}
