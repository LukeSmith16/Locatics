//
//  MockLocationStorage.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocationStorage: LocationStorageInterface {
    var calledSaveLocationOnDisk = false

    var lastVisitedLocation: VisitedLocationData?

    func saveLocationOnDisk(_ location: VisitedLocation) {
        calledSaveLocationOnDisk = true
        lastVisitedLocation = location
    }
}
