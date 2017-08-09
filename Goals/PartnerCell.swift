//
//  PartnerCell.swift
//  Goals
//
//  Created by Gerardo Parra on 8/8/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Charts

class PartnerCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var goalBackground: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    
    var partnerInfo: [String: Any] = [:] {
        didSet {
            usernameLabel.text = partnerInfo["username"] as? String
            goalTitleLabel.text = partnerInfo["goalTitle"] as? String
            streakLabel.text = "🔥" + String(partnerInfo["streak"] as! Int)
            
            updatesMade = partnerInfo["chartData"] as! [Int]
            var chartData: [Double] = []
            for num in updatesMade {
                chartData.append(Double(exactly: num)!)
            }
            setChart(dataPoints: days, values: chartData)
        }
    }

    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var updatesMade : [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.layer.cornerRadius = 10
        goalBackground.layer.cornerRadius = 10
        userIcon.layer.cornerRadius = userIcon.frame.height / 2
        
        axisFormatDelegate = self as? IAxisValueFormatter
        
        let xAxis = graphView.xAxis
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()
        
        graphView.notifyDataSetChanged()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        graphView.chartDescription?.text = ""
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Updates Made")
        let chartData = LineChartData(dataSet: chartDataSet)
        graphView.data = chartData
        
        // Settings for the graph
        chartDataSet.colors = [UIColor.white]
        chartDataSet.circleColors = [NSUIColor.white]
        chartDataSet.circleHoleRadius = CGFloat(0)
        chartDataSet.circleRadius = CGFloat(3)
        chartDataSet.drawValuesEnabled = false
        
        graphView.xAxis.labelTextColor = UIColor.clear
        graphView.xAxis.axisLineColor = UIColor.clear
        graphView.tintColor = UIColor.white
        graphView.xAxis.labelPosition = .bottom
        graphView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInBounce)
        graphView.scaleYEnabled = false
        graphView.scaleXEnabled = false
        graphView.pinchZoomEnabled = false
        graphView.doubleTapToZoomEnabled = false
        graphView.xAxis.drawGridLinesEnabled = false
        graphView.leftAxis.drawGridLinesEnabled = false
        graphView.rightAxis.drawGridLinesEnabled = false
        graphView.rightAxis.drawLabelsEnabled = false
        graphView.legend.enabled = false
        graphView.highlightPerTapEnabled = false
        graphView.dragEnabled = false
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = false
    }
}
