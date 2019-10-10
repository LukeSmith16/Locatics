//
//  MockCLPlacemark.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

@testable import Locatics
class MockCLPlacemark: CLPlacemark {
    override var thoroughfare: String? {
        return "TestThoroughfare"
    }
}
