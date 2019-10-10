//
//  MockCLVisit.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import CoreLocation

class MockCLVisit: CLVisit, Codable {
    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 25.0, longitude: 50.0)
    }

    override var arrivalDate: Date {
        return Date()
    }
}
