//
//  LocaticMarkerAnnotationView.swift
//  Locatics
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import MapKit

final class LocaticMarkerAnnotationView: MKAnnotationView {
    convenience init(annotation: MKAnnotation, reuseIdentifier: String, image: UIImage?) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure(with: annotation, image: image)
    }
}

private extension LocaticMarkerAnnotationView {
    func configure(with annotation: MKAnnotation, image: UIImage?) {
        self.collisionMode = .circle
        self.canShowCallout = true
        self.image = image
        self.clusteringIdentifier = String(describing: LocaticMarkerAnnotationView.self)
    }
}
