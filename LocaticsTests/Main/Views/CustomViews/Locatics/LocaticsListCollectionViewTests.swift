//
//  LocaticsListCollectionViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsListCollectionViewTests: XCTestCase {

    var sut: LocaticsListCollectionView!

    override func setUp() {
        sut = LocaticsListCollectionView(frame: .zero)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

}
