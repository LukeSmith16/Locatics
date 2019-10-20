//
//  MockLocaticsMainMapViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsMainMapViewModelViewDelegate: LocaticsMainMapViewModelViewDelegate {
    var calledShowAlert = false

    var passedAlertTitle: String?
    var passedAlertMessage: String?
    func showAlert(title: String, message: String) {
        calledShowAlert = true

        passedAlertTitle = title
        passedAlertMessage = message
    }
}
