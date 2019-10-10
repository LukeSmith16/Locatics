//
//  LocaticMarkerAnnotationView.swift
//  Locatics
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import MapKit

final class LocaticMarkerAnnotationView: MKPinAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            newValue.flatMap(configure(with:))
        }
    }
}

private extension LocaticMarkerAnnotationView {
    func configure(with annotation: MKAnnotation) {
        self.collisionMode = .circle
        self.clusteringIdentifier = String(describing: LocaticMarkerAnnotationView.self)
    }
}
