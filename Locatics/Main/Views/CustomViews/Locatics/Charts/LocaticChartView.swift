//
//  LocaticChartView.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Charts

class LocaticChartView: LineChartView {
    var locaticChartViewModel: LocaticChartViewModelInterface? {
        didSet {
            setupChart()
        }
    }
}

private extension LocaticChartView {
    func setupChart() {
        setupXAxis()
        setupRightAxis()
        setupLeftAxis()
        setupBackgroundChart()
        setupUserInteraction()
        setupChartData()
        setupChartVisibleView()
    }

    func setupXAxis() {
        xAxis.valueFormatter = LocaticChartXAxisDateFormatter(dateFormatter: locaticChartViewModel!.dateFormatter)

        xAxis.labelPosition = .bottom

        xAxis.granularityEnabled = true
        xAxis.granularity = 1.0

        xAxis.yOffset = 20

        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false

        xAxis.labelTextColor = UIColor(colorTheme: .Title_Secondary)
        xAxis.labelFont = Font.init(.installed(.HelveticaRegular), size: .standard(.h4)).instance

        xAxis.setLabelCount(7, force: true)
    }

    func setupLeftAxis() {
        leftAxis.enabled = false
    }

    func setupRightAxis() {
        rightAxis.enabled = false
    }

    func setupBackgroundChart() {
        self.drawGridBackgroundEnabled = false
        self.legend.enabled = false
    }

    func setupUserInteraction() {
        self.doubleTapToZoomEnabled = false
        self.highlightPerDragEnabled = false
        self.isUserInteractionEnabled = false
    }

    func setupChartData() {
        let lineChartData = getLineChartData()
        self.data = lineChartData
        self.setVisibleXRangeMaximum(7)
    }

    func getLineChartData() -> LineChartData {
        let dataEntries = chartDataEntries()

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        setupLineChartDataSetGraphics(dataSet: lineChartDataSet)

        let lineChartDataSetWithCircle = LineChartDataSet(entries: [dataEntries.last!], label: nil)
        setupLineChartDataSetGraphicsWithCircle(dataSet: lineChartDataSetWithCircle)

        let chartData = LineChartData(dataSets: [lineChartDataSet, lineChartDataSetWithCircle])
        chartData.setDrawValues(false)

        return chartData
    }

    func chartDataEntries() -> [ChartDataEntry] {
        let entries = locaticChartViewModel!.locaticChartDataEntries

        return entries.map { (dataEntry: LocaticChartDataEntryInterface) -> ChartDataEntry in
            let timeIntervalForDate: TimeInterval = dataEntry.entryDate.timeIntervalSince1970
            let dataEntry = ChartDataEntry(x: Double(timeIntervalForDate), y: dataEntry.entryValue ?? 0.0)

            return dataEntry
        }
    }

    func setupLineChartDataSetGraphics(dataSet: LineChartDataSet) {
        dataSet.lineWidth = 2
        dataSet.setColors(UIColor(colorTheme: .Interactable_Main))

        dataSet.drawFilledEnabled = false
        dataSet.drawCirclesEnabled = false

        dataSet.mode = .horizontalBezier
        dataSet.axisDependency = .right
    }

    func setupLineChartDataSetGraphicsWithCircle(dataSet: LineChartDataSet) {
        dataSet.circleColors = [UIColor(colorTheme: .Interactable_Main)]
        dataSet.circleHoleColor = UIColor(colorTheme: .Interactable_Main)

        dataSet.circleRadius = 6.0
        dataSet.drawCirclesEnabled = true

        dataSet.mode = .horizontalBezier
        dataSet.axisDependency = .right
    }

    func setupChartVisibleView() {
        self.setVisibleXRange(minXRange: 1.0, maxXRange: 1.0)
        self.viewPortHandler.setMaximumScaleX(1.0)
    }
}

extension LocaticChartView: ChartViewDelegate {}
