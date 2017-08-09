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
    @IBOutlet weak var goalEdges: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var alertButton: UIButton!
    
    var partnerInfo: [String: Any] = [:] {
        didSet {
            usernameLabel.text = partnerInfo["username"] as? String
            userIcon.image = partnerInfo["icon"] as? UIImage
            goalTitleLabel.text = partnerInfo["goalTitle"] as? String
            streakLabel.text = "🔥" + String(partnerInfo["streak"] as! Int)
            alertButton.setTitle(String(partnerInfo["alerts"] as! Int), for: .normal)
            
            let trend = partnerInfo["trend"] as! String
            if trend == "positive" {
                cellBackground.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
                goalBackground.backgroundColor = UIColor(red:0.50, green:0.85, blue:0.60, alpha:1.0)
                goalEdges.backgroundColor = goalBackground.backgroundColor
            } else if trend == "negative" {
                cellBackground.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
                goalBackground.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
                goalEdges.backgroundColor = goalBackground.backgroundColor
            } else {
                cellBackground.backgroundColor = UIColor(red: 0.35, green: 0.40, blue: 0.70, alpha: 1.0)
                goalBackground.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
                goalEdges.backgroundColor = goalBackground.backgroundColor
            }
            graphView.backgroundColor = cellBackground.backgroundColor
            
            
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
        alertButton.layer.cornerRadius = alertButton.frame.height / 2
        
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
        
        graphView.xAxis.labelTextColor = UIColor.lightGray
        graphView.xAxis.axisLineColor = UIColor.lightGray
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
