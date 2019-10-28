//
//  LocaticCollectionViewCellTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticCollectionViewCellTests: XCTestCase {

    var sut: LocaticCollectionViewCell!

    private var mockCollectionView: MockCollectionView!

    override func setUp() {
        mockCollectionView = MockCollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())

        let nib = UINib(nibName: "LocaticCollectionViewCell", bundle: nil)
        mockCollectionView.register(nib, forCellWithReuseIdentifier: "LocaticCollectionViewCell")

        sut = mockCollectionView.dequeueReusableCell(withReuseIdentifier: "LocaticCollectionViewCell",
                                                     for: IndexPath(item: 0, section: 0)) as? LocaticCollectionViewCell
    }

    override func tearDown() {
        sut = nil
        mockCollectionView = nil
        super.tearDown()
    }

    func test_locaticCellViewModel_isNil() {
        XCTAssertNil(sut.locaticCellViewModel)
    }

    func test_awakeFromNib_setsUpViews() {
        XCTAssertEqual(sut.cellView.backgroundColor,
                       UIColor(colorTheme: .Background))
        XCTAssertEqual(sut.cellView.layer.cornerRadius, 8.0)

        XCTAssertFalse(sut.locaticIconImageView.clipsToBounds)

        XCTAssertEqual(sut.cellView.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(sut.cellView.layer.shadowOpacity, 0.15)
        XCTAssertEqual(sut.cellView.layer.shadowOffset, CGSize(width: 0, height: 4))

        XCTAssertEqual(sut.locaticNameLabel.font,
                       Font.init(.installed(.HelveticaRegular), size: .standard(.h1)).instance)
        XCTAssertEqual(sut.locaticTimeSpentLabel.font,
                       Font.init(.installed(.HelveticaRegular), size: .standard(.h3)).instance)

        XCTAssertEqual(sut.locaticNameLabel.textColor, UIColor(colorTheme: .Title_Main))
        XCTAssertEqual(sut.locaticTimeSpentLabel.textColor, UIColor(colorTheme: .Title_Secondary))
    }

    func test_settingLocaticCellViewModel_configuresCellViews() {
        let mockLocaticCellViewModel = MockLocaticCellViewModel()
        sut.locaticCellViewModel = mockLocaticCellViewModel

        XCTAssertEqual(sut.locaticNameLabel.text, mockLocaticCellViewModel.locatic.name)
        XCTAssertEqual(sut.locaticTimeSpentLabel.text, mockLocaticCellViewModel.hoursSpentThisWeek)

        XCTAssertNotNil(sut.locaticChartView.locaticChartViewModel)
        XCTAssertNotNil(sut.locaticIconImageView.image)
    }
}
