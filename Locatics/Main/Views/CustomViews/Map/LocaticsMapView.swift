//
//  LocaticsMapView.swift
//  Locatics
//
//  Created by Luke Smith on 06/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import MapKit

class LocaticsMapView: MKMapView {
    var addLocaticMapRadiusCircle: MKCircle?
    var addLocaticMapCircleRadius: Double?

    var locaticsMapViewModel: LocaticsMapViewModelInterface? {
        didSet {
            locaticsMapViewModel?.viewDelegate = self
            setupMapView()
        }
    }

    func goToUserRegion() {
        locaticsMapViewModel?.goToUserRegion()
    }

    func removeAddLocaticRadiusAnnotation() {
        guard let addLocaticMapRadiusCircle = addLocaticMapRadiusCircle else {
            return
        }

        removeOverlay(addLocaticMapRadiusCircle)
        self.addLocaticMapRadiusCircle = nil
    }
}

private extension LocaticsMapView {
    func setupMapView() {
        self.delegate = self
        self.showsUserLocation = true
        self.tintColor = UIColor(colorTheme: .Interactable_Secondary)
        register(LocaticMarkerAnnotationView.self,
                 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        register(LocaticClusterMarkerView.self,
                 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        locaticsMapViewModel?.getAllLocatics()
    }
}

extension LocaticsMapView: LocaticsMapViewModelViewDelegate, AddLocaticMapRadiusAnnotationViewDelegate {
    func zoomToUserLocation(latMeters: Double, lonMeters: Double) {
        updateMapRegion(location: userLocation.coordinate,
                        latMeters: latMeters,
                        lonMeters: lonMeters)
    }

    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: latMeters,
                                                  longitudinalMeters: lonMeters)
        setRegion(coordinateRegion, animated: true)
    }

    func updatePinAnnotationRadius(toRadius radius: Double) {
        removeAddLocaticRadiusAnnotation()
        self.addLocaticMapCircleRadius = radius
        setupAddLocaticMapRadiusCircle()
    }

    func addLocaticMapAnnotation(_ locatic: LocaticData) {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = Coordinate(latitude: locatic.latitude,
                                                longitude: locatic.longitude)

        let pinAnnotationView = LocaticMarkerAnnotationView(annotation: pointAnnotation,
                                                            reuseIdentifier: "LocaticMarkerAnnotationView")
//        pinAnnotationView.image = UIImage(named: "addL") // MARK: - TODO

        addAnnotation(pinAnnotationView.annotation!)
    }
}

extension LocaticsMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.fillColor = UIColor.orange

        return circleView
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard addLocaticMapRadiusCircle != nil else { return }
        removeAddLocaticRadiusAnnotation()
        setupAddLocaticMapRadiusCircle()
    }
}

private extension LocaticsMapView {
    private func setupAddLocaticMapRadiusCircle() {
        let locationPinCoordinate = locaticsMapViewModel!.getLocationPinCoordinate()
        self.addLocaticMapRadiusCircle = MKCircle(center: locationPinCoordinate, radius: addLocaticMapCircleRadius!)
        addOverlay(addLocaticMapRadiusCircle!)
    }
}
