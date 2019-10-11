//
//  MockLocaticVisitStorage.swift
//  LocaticsTests
//
//  Created by Luke Smith on 11/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticVisitStorage: LocaticVisitStorageInterface {

    var calledInsertLocaticVisit = false
    var calledUpdateLocaticVisit = false

    var shouldFail = false

    var changedEntryDate: Date?
    var changedLocatic: LocaticData?
    func insertLocaticVisit(entryDate: Date,
                            locatic: LocaticData,
                            completion: @escaping (StorageManagerError?) -> Void) {
        calledInsertLocaticVisit = true
        if shouldFail {
            completion(.couldNotFindObject)
        } else {
            completion(nil)
        }

        changedEntryDate = entryDate
        changedLocatic = locatic
    }

    var changedLocaticVisit: LocaticVisitData?
    var changedExitDate: Date?
    func updateLocaticVisit(locaticVisit: LocaticVisitData,
                            exitDate: Date,
                            completion: @escaping (StorageManagerError?) -> Void) {
        calledUpdateLocaticVisit = true
        if shouldFail {
            completion(.couldNotFindObject)
        } else {
            completion(nil)
        }

        changedLocaticVisit = locaticVisit
        changedExitDate = exitDate
    }
}
