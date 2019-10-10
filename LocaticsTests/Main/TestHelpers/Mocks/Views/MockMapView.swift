//
//  MockMapView.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockMapView: LocaticsMapView {
    var calledGoToUserRegion = false
    var calledRemoveAddLocaticRadiusAnnotation = false

    override func goToUserRegion() {
        calledGoToUserRegion = true
    }

    override func removeAddLocaticRadiusAnnotation() {
        calledRemoveAddLocaticRadiusAnnotation = true
    }
}
