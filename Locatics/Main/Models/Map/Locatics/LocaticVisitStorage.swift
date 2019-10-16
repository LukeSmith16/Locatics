//
//  LocaticVisitStorage.swift
//  Locatics
//
//  Created by Luke Smith on 11/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable empty_enum_arguments

import Foundation

protocol LocaticVisitStorageInterface: class {
    func insertLocaticVisit(entryDate: Date,
                            locatic: LocaticData)
    func updateLocaticVisit(locaticVisit: LocaticVisitData,
                            exitDate: Date)
}

class LocaticVisitStorage: LocaticVisitStorageInterface {
    private let storageManager: StorageManagerInterface

    init(storageManager: StorageManagerInterface) {
        self.storageManager = storageManager
    }

    func insertLocaticVisit(entryDate: Date,
                            locatic: LocaticData) {
        guard let locaticObject = locatic as? Locatic else {
            fatalError("Locatic should be on concrete type 'Locatic'")
        }

        var values: [String: Any] = [:]
        values["entryDate"] = entryDate
        values["locatic"] = locaticObject

        storageManager.createObject(entity: LocaticVisit.self, values: values) { (_) in}
    }

    func updateLocaticVisit(locaticVisit: LocaticVisitData,
                            exitDate: Date) {
        var changedValues: [String: Any] = [:]
        changedValues["exitDate"] = exitDate

        storageManager.updateObject(entity: LocaticVisit.self,
                                    identity: locaticVisit.identity,
                                    updatedValues: changedValues) { (_) in}
    }
}
