//
//  InfoCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/19/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import Charts
import RealmSwift
import ParseUI

class InfoCell: UITableViewCell, ChartViewDelegate {
    //graph goes here
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var progressBackground: LineChartView!
    @IBOutlet weak var infoBackground: UIView!
    @IBOutlet weak var nodeView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var days: [String] = []
    var updatesMade : [Double] = []
    
    var data: PFObject! {
        didSet {
            headerLabel.text = data?["title"] as? String

            
            // Set timestamp
            let date = data?.createdAt!
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M/d/yyyy"
            let timestampString = String(dateFormat.string(from: date!))
            timestampLabel.text = String("Began this goal on " + timestampString!)
            
            updatesMade = data["updatesPerDay"] as! [Double]
            setChart(dataPoints: days, values: updatesMade)
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Style views
        infoBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        progressBackground.layer.cornerRadius = 14
        //Graph Data/Setup
        axisFormatDelegate = self as? IAxisValueFormatter
        days = ["M", "Tu", "W", "Th", "F", "Sa", "Su"]
        
        let xAxis = progressBackground.xAxis
        print(xAxis)
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()
        //print(xAxis.valueFormatter)

        progressBackground.notifyDataSetChanged()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        progressBackground.chartDescription?.text = ""
        progressBackground.backgroundColor = UIColor(red:0.60, green:0.68, blue:0.96, alpha:1.0)
        
        var dataEntries: [ChartDataEntry] = []
        
//        var intValues: [Int] = []
//        for i in values {
//            intValues.append(Int(values[i]))
//        }
    
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        //convert data entry y values to ints
        //print(dataEntries)
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Updates Made")
        let chartData = LineChartData(dataSet: chartDataSet)
        progressBackground.data = chartData
        
//        let sum = values.reduce(0, +)
//        let average = sum / 7
//        let average1 = average - 1.02
        
        //Settings for the Bar graph
        chartDataSet.colors = [UIColor(red:0.77, green:0.97, blue:0.76, alpha:1.0)]
        progressBackground.xAxis.labelPosition = .bottom
        progressBackground.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        progressBackground.scaleYEnabled = false
        progressBackground.scaleXEnabled = false
        progressBackground.pinchZoomEnabled = false
        progressBackground.doubleTapToZoomEnabled = false
        progressBackground.xAxis.drawGridLinesEnabled = false
        progressBackground.leftAxis.drawGridLinesEnabled = false
        progressBackground.rightAxis.drawGridLinesEnabled = false
        progressBackground.rightAxis.drawLabelsEnabled = false
        progressBackground.legend.enabled = true
        
        // Updates/Average Limit Lines
//        let averageEstimate = ChartLimitLine(limit: average, label: "Est. Updates Per Week")
//        averageEstimate.valueFont = UIFont(name: "Verdana", size: 8.0)!
//        averageEstimate.lineColor = UIColor.gray
//        progressBackground.rightAxis.addLimitLine(averageEstimate)
//        averageEstimate.labelPosition = .leftTop
//        
//        let actualAverage = ChartLimitLine(limit: average1, label: "Your average")
//        actualAverage.valueFont = UIFont(name: "Verdana", size: 8.0)!
//        if average1 > average {
//            actualAverage.lineColor = UIColor.green
//            progressBackground.rightAxis.addLimitLine(actualAverage)
//        } else if average1 < average {
//            actualAverage.lineColor = UIColor.red
//            progressBackground.rightAxis.addLimitLine(actualAverage)
//        } else if average1 == average {
//            actualAverage.lineColor = UIColor.green
//            progressBackground.rightAxis.addLimitLine(actualAverage)
//        }


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
