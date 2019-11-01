//
//  LocaticChartViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import Charts

@testable import Locatics
class LocaticChartViewTests: XCTestCase {

    var sut: LocaticChartView!

    private var mockLocaticChartViewModel: MockLocaticChartViewModel!

    override func setUp() {
        sut = LocaticChartView(frame: .zero)
        mockLocaticChartViewModel = MockLocaticChartViewModel()

        sut.locaticChartViewModel = mockLocaticChartViewModel
    }

    override func tearDown() {
        sut = nil
        mockLocaticChartViewModel = nil
        super.tearDown()
    }

    func test_setupChart_setupXAxis() {
        XCTAssertNotNil(sut.xAxis.valueFormatter)
        XCTAssertTrue(sut.xAxis.valueFormatter is LocaticChartXAxisDateFormatter)

        XCTAssertTrue(sut.xAxis.labelPosition == .bottom)

        XCTAssertTrue(sut.xAxis.granularityEnabled)
        XCTAssertEqual(sut.xAxis.granularity, 1.0)

        XCTAssertEqual(sut.xAxis.yOffset, 20)

        XCTAssertFalse(sut.xAxis.drawAxisLineEnabled)
        XCTAssertFalse(sut.xAxis.drawGridLinesEnabled)

        XCTAssertEqual(sut.xAxis.labelTextColor, UIColor(colorTheme: .Title_Secondary))
        XCTAssertEqual(sut.xAxis.labelFont,
                       Font.init(.installed(.HelveticaRegular), size: .standard(.h4)).instance)

        XCTAssertEqual(sut.xAxis.labelCount, 7)
    }

    func test_setupChart_setupLeftAxis() {
        XCTAssertFalse(sut.leftAxis.enabled)
    }

    func test_setupChart_setupRightAxis() {
        XCTAssertFalse(sut.rightAxis.enabled)
    }

    func test_setupChart_setupBackgroundChart() {
        XCTAssertFalse(sut.drawGridBackgroundEnabled)
        XCTAssertFalse(sut.legend.enabled)
    }

    func test_setupChart_setupUserInteraction() {
        XCTAssertFalse(sut.doubleTapToZoomEnabled)
        XCTAssertFalse(sut.highlightPerDragEnabled)
        XCTAssertFalse(sut.isUserInteractionEnabled)
    }

    func test_setupChart_setupChartData() {
        XCTAssertNotNil(sut.data)
    }

    func test_setupChart_getLineChartData() {
        let chartData = sut.data!

        XCTAssertTrue(chartData is LineChartData)
        XCTAssertEqual(chartData.dataSets.count, 2)
    }

    func test_setupChart_setupLineChartDataSetGraphics() {
        let chartData = sut.data!

        guard let lineChartDataSetWithoutCircle = chartData.dataSets.first as? LineChartDataSet else {
            XCTFail("lineChartDataSetWithoutCircle should be of type 'LineChartDataSet'")
            return
        }

        XCTAssertEqual(lineChartDataSetWithoutCircle.entries.count,
                       1)

        XCTAssertEqual(lineChartDataSetWithoutCircle.lineWidth, 2)
        XCTAssertEqual(lineChartDataSetWithoutCircle.colors.count, 1)

        XCTAssertEqual(lineChartDataSetWithoutCircle.colors.first!,
                       UIColor(colorTheme: .Interactable_Main))

        XCTAssertFalse(lineChartDataSetWithoutCircle.drawFilledEnabled)
        XCTAssertFalse(lineChartDataSetWithoutCircle.drawCirclesEnabled)

        XCTAssertTrue(lineChartDataSetWithoutCircle.mode == .horizontalBezier)
        XCTAssertTrue(lineChartDataSetWithoutCircle.axisDependency == .right)

        guard let lineChartDataSetWithCircle = chartData.dataSets.last as? LineChartDataSet else {
            XCTFail("lineChartDataSetWithoutCircle should be of type 'LineChartDataSet'")
            return
        }

        XCTAssertEqual(lineChartDataSetWithoutCircle.entries.count,
                       1)

        XCTAssertEqual(lineChartDataSetWithCircle.circleColors.count, 1)
        XCTAssertEqual(lineChartDataSetWithCircle.circleColors.first!,
                       UIColor(colorTheme: .Interactable_Main))

        XCTAssertEqual(lineChartDataSetWithCircle.circleHoleColor!,
                       UIColor(colorTheme: .Interactable_Main))

        XCTAssertEqual(lineChartDataSetWithCircle.circleRadius, 6.0)
        XCTAssertTrue(lineChartDataSetWithCircle.drawCirclesEnabled)

        XCTAssertTrue(lineChartDataSetWithCircle.mode == .horizontalBezier)
        XCTAssertTrue(lineChartDataSetWithCircle.axisDependency == .right)
    }

    func test_setupChart_setupChartVisibleView() {
        XCTAssertEqual(sut.viewPortHandler.maxScaleX, 1.0)
    }
}
