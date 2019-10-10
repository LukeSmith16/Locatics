//
//  MockLocaticEntryValidationDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticEntryValidationDelegate: LocaticEntryValidationDelegate {
    var calledValidationErrorOccured = false
    var calledCloseAddLocaticCardView = false

    var errorValue: String?
    func validationErrorOccured(_ error: String) {
        calledValidationErrorOccured = true
        errorValue = error
    }

    func closeAddLocaticCardView() {
        calledCloseAddLocaticCardView = true
    }
}
