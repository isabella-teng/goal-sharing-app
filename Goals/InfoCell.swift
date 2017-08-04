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
    @IBOutlet weak var progressBackground: UIView!
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var infoBackground: UIView!
    @IBOutlet weak var nodeView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var updatesCountLabel: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var days: [String] = []
    var updatesMade : [Double] = []
    
    var data: PFObject! { //current goal
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
            
            let author = data["author"] as! PFUser
//            descriptionLabel.text = "Description: " + (data["description"] as! String)
            authorLabel.text = "Author: " + author.username!
            updatesCountLabel.text = "Total Updates: " + (String(data["updatesCount"] as! Int))
            categoryLabel.text = data["categories"] as! String
            
            if (data["isCompleted"] as! Bool == true) {
                let completedString = String(dateFormat.string(from: data["actualCompletionDate"] as! Date))
                completionDate.text = "Finished goal on " + completedString!
            } else {
                let completedString = String(dateFormat.string(from: data["completionDate"] as! Date))
                completionDate.text = "Intended Completion Date: " + completedString!
            }
            
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style views
        infoBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        progressBackground.layer.cornerRadius = 10
        
        // Set up graph
        axisFormatDelegate = self as? IAxisValueFormatter
        days = ["M", "T", "W", "T", "F", "S", "S"]
        
        let xAxis = graphView.xAxis
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()

        graphView.notifyDataSetChanged()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        graphView.chartDescription?.text = ""
        graphView.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
        progressBackground.backgroundColor = graphView.backgroundColor
        
        var dataEntries: [ChartDataEntry] = []
        
//        var intValues: [Int] = []
//        for i in values {
//            intValues.append(Int(values[i]))
//        }
    
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Updates Made")
        let chartData = LineChartData(dataSet: chartDataSet)
        graphView.data = chartData
        
//        let sum = values.reduce(0, +)
//        let average = sum / 7
//        let average1 = average - 1.02
        
        // Settings for the graph
        chartDataSet.colors = [UIColor.white]
        chartDataSet.circleColors = [NSUIColor.white]
        chartDataSet.circleHoleRadius = CGFloat(0)
        chartDataSet.circleRadius = CGFloat(3)
        chartDataSet.drawValuesEnabled = false
        
        graphView.xAxis.labelTextColor = UIColor.darkGray
        graphView.xAxis.axisLineColor = UIColor.darkGray
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
