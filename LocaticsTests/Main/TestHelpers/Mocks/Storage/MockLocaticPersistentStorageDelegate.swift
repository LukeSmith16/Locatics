//
//  MockLocaticPersistentStorageDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticPersistentStorageDelegate: LocaticPersistentStorageDelegate {
    var calledLocaticWasInserted = false
    var calledLocaticWasUpdated = false
    var calledLocaticWasDeleted = false

    var insertedValue: LocaticData?
    func locaticWasInserted(_ insertedLocatic: LocaticData) {
        insertedValue = insertedLocatic
        calledLocaticWasInserted = true
    }

    var updatedValue: LocaticData?
    func locaticWasUpdated(_ updatedLocatic: LocaticData) {
        updatedValue = updatedLocatic
        calledLocaticWasUpdated = true
    }

    var deletedValue: LocaticData?
    func locaticWasDeleted(_ deletedLocatic: LocaticData) {
        deletedValue = deletedLocatic
        calledLocaticWasDeleted = true
    }
}
