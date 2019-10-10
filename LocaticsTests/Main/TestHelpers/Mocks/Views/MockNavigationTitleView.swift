//
//  MockNavigationTitleView.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockNavigationTitleView: NavigationTitleViewInterface {
    var calledSetNewTitle = false
    var calledSetNewSubtitle = false

    var setNewTitleValue = ""
    var setNewSubTitleValue = ""

    func setNewTitle(_ title: String?) {
        calledSetNewTitle = true
        setNewTitleValue = title ?? ""
    }

    func setNewSubtitle(_ subtitle: String?) {
        calledSetNewSubtitle = true
        setNewSubTitleValue = subtitle ?? ""
    }
}
