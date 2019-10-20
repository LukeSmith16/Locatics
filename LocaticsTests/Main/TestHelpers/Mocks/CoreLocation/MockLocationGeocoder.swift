//
//  MockLocationGeocoder.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreLocation

@testable import Locatics
class MockLocationGeocoder: LocationGeocoderInterface {
    var calledReverseGeocodeLocation = false
    var locationPassed: CLLocation?

    let placemark = MockCLPlacemark()

    var shouldFail = false

    func reverseGeocodeLocation(_ location: CLLocation,
                                completionHandler: @escaping CLGeocodeCompletionHandler) {
        calledReverseGeocodeLocation = true
        locationPassed = location

        if shouldFail {
            completionHandler(nil, NSError())
        } else {
            completionHandler([placemark], nil)
        }
    }
}
