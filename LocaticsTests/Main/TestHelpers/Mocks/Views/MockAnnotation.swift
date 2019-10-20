//
//  MockAnnotation.swift
//  LocaticsTests
//
//  Created by Luke Smith on 14/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import MapKit

class MockAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 10,
                                      longitude: 10)
    }
}
