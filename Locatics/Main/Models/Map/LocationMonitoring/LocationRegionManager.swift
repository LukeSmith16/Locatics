//
//  LocationRegionManager.swift
//  Locatics
//
//  Created by Luke Smith on 15/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable empty_enum_arguments

import Foundation

protocol LocationRegionManagerInterface: class {
    func userDidEnterLocaticRegion(regionIdentifier: String)
    func userDidLeaveLocaticRegion(regionIdentifier: String)
}

class LocationRegionManager: LocationRegionManagerInterface {

    private let locaticStorage: LocaticStorageInterface
    private let locaticVisitStorage: LocaticVisitStorageInterface

    init(locaticStorage: LocaticStorageInterface,
         locaticVisitStorage: LocaticVisitStorageInterface) {
        self.locaticStorage = locaticStorage
        self.locaticVisitStorage = locaticVisitStorage
    }

    func userDidEnterLocaticRegion(regionIdentifier: String) {
        fetchLocaticMatchingName(regionIdentifier) { [weak self] (locatic) in
            guard let locatic = locatic else { return }

            self?.locaticVisitStorage.insertLocaticVisit(entryDate: Date(),
                                                         locatic: locatic)
        }
    }

    func userDidLeaveLocaticRegion(regionIdentifier: String) {
        fetchLocaticMatchingName(regionIdentifier) { [weak self] (locatic) in
            guard let locatic = locatic else { return }

            guard let locaticVisits = locatic.locaticVisits?.array as? [LocaticVisitData],
                let recentLocaticVisit = locaticVisits.first(where: { $0.exitDate == nil }) else {
                    return
            }

            self?.locaticVisitStorage.updateLocaticVisit(locaticVisit: recentLocaticVisit,
                                                         exitDate: Date())
        }
    }
}

private extension LocationRegionManager {
    func fetchLocaticMatchingName(_ locaticName: String,
                                  completionHandler: @escaping (_ locatic: LocaticData?) -> Void) {
        let matchingNamePredicate = NSPredicate(format: "%K == %@", #keyPath(Locatic.name), locaticName)
        locaticStorage.fetchLocatics(predicate: matchingNamePredicate,
                                     sortDescriptors: nil,
                                     completion: { (result) in
                                        switch result {
                                        case .success(let success):
                                            completionHandler(success.first)
                                        case .failure(_):
                                            completionHandler(nil)
                                        }
        })
    }
}
