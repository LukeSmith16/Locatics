//
//  MockLocaticsMainViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsMainViewModelViewDelegate: LocaticsMainViewModelViewDelegate {
    var calledSetNavigationTitle = false
    var calledShowAlert = false

    func setNavigationTitle(_ title: String) {
        calledSetNavigationTitle = true
    }

    var passedTitle: String?
    var passedMessage: String?
    func showAlert(title: String, message: String) {
        self.passedTitle = title
        self.passedMessage = message

        calledShowAlert = true
    }
}
