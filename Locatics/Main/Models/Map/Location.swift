//
//  Location.swift
//  Locatics
//
//  Created by Luke Smith on 08/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreLocation

protocol VisitedLocationData: LocationData {
    var latitude: Double {get}
    var longitude: Double {get}
    var date: Date {get}
    var description: String {get}
}

class VisitedLocation: Codable, VisitedLocationData {

    let latitude: Double
    let longitude: Double
    let date: Date
    let description: String

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(_ location: CLLocationCoordinate2D, date: Date, description: String) {
        self.latitude =  location.latitude
        self.longitude =  location.longitude
        self.date = date
        self.description = description
    }

    convenience init(visit: CLVisit, description: String) {
        self.init(visit.coordinate, date: visit.arrivalDate, description: description)
    }
}
