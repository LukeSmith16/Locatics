//
//  MockTabBarController.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics
class MockTabBarController: TabBarControllerInterface {
    var onMapFlowSelect: ((UINavigationController) -> Void)?
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)?

    func triggerRunMapFlow() {
        onMapFlowSelect?(UINavigationController())
    }

    func triggerRunLocaticsFlow() {
        onLocaticsFlowSelect?(UINavigationController())
    }
}
