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
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Style views
        progressBackground.layer.cornerRadius = 10
        infoBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        
        //Graph Data/Setup
        axisFormatDelegate = self as? IAxisValueFormatter
        days = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
//        let updatesMade = [1.0,7.0,4.0,6.0,2.0,6.0,9.0]
        
        let xAxis = progressBackground.xAxis
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()
        
        //Call setChart Function
//        setChart(dataPoints: days, values: updatesMade)

        progressBackground.notifyDataSetChanged()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        progressBackground.chartDescription?.text = ""
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Updates Made")
        let chartData = LineChartData(dataSet: chartDataSet)
        progressBackground.data = chartData
        
//        let sum = values.reduce(0, +)
//        let average = sum / 7
//        let average1 = average - 1.02
        
        //Settings for the Bar graph
        chartDataSet.colors = [UIColor(red: 255/255, green: 95/255, blue: 107/255, alpha: 1)]
        progressBackground.xAxis.labelPosition = .bottom
        progressBackground.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
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
