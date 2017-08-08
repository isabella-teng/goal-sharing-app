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

protocol InfoCellGoalDelegate: class {
    func infoCellGoal(_ infoCell: InfoCell, didTap goal: PFObject)
}

class InfoCell: UITableViewCell, ChartViewDelegate {
    //graph goes here
    
    weak var delegate: InfoCellGoalDelegate?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var progressBackground: UIView!
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var infoBackground: UIView!
    @IBOutlet weak var nodeView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorIcon: UIImageView!
    @IBOutlet weak var updatesCountLabel: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var descriptionBackground: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var streakCountLabel: UILabel!
    @IBOutlet weak var completionProgressView: UIProgressView!
    @IBOutlet weak var totalUpdatesLabel: UILabel!
    
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
            
            let author = data["author"] as! PFUser
            authorLabel.text = author.username!
            let iconUrl = author["portrait"] as? PFFile
            iconUrl?.getDataInBackground(block: { (image: Data?, error: Error?) in
                if error == nil {
                    self.authorIcon.image = UIImage(data: image!)
                }
            })
            updatesCountLabel.text = String(data["updatesCount"] as! Int) + " Updates"
            
            if data["categories"]  as! String == "Education" {
                categoryIcon.image = #imageLiteral(resourceName: "education").withRenderingMode(.alwaysTemplate)
                categoryIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            } else if data["categories"]  as! String == "Health" {
                categoryIcon.image = #imageLiteral(resourceName: "health").withRenderingMode(.alwaysTemplate)
                categoryIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            } else if data["categories"]  as! String == "Fun" {
                categoryIcon.image = #imageLiteral(resourceName: "fun").withRenderingMode(.alwaysTemplate)
                categoryIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            } else if data["categories"]  as! String == "Money" {
                categoryIcon.image = #imageLiteral(resourceName: "money").withRenderingMode(.alwaysTemplate)
                categoryIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            } else if data["categories"]  as! String == "Spiritual" {
                categoryIcon.image = #imageLiteral(resourceName: "spiritual").withRenderingMode(.alwaysTemplate)
                categoryIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            }else if data["categories"]  as! String == "Other" {
                categoryIcon.image = #imageLiteral(resourceName: "other").withRenderingMode(.alwaysTemplate)
                categoryIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            }
            
            if (data["isCompleted"] as! Bool == true) {
                let completedString = String(dateFormat.string(from: data["actualCompletionDate"] as! Date))
                completionDate.text = "Completed " + completedString!
            } else {
                let completedString = String(dateFormat.string(from: data["completionDate"] as! Date))
                completionDate.text = "Due " + completedString!
            }
            
            descriptionLabel.text = data["description"] as? String
            
            let updateCount = data["updatesCount"] as! Int
            if updateCount == 1 {
                totalUpdatesLabel.text = String(describing: updateCount) + " Update"
            } else {
                totalUpdatesLabel.text = String(describing: updateCount) + " Updates"
            }

            streakCountLabel.text = String(describing: data["streakCount"] as! Int) + " day streak"
            
            if data["isCompleted"] as! Bool == true {
                completionProgressView.progress = 1
            } else {
                let startToCurrent = calculateDaysBetweenTwoDates(start: data.createdAt!, end: Date())
                let startToCompletion = calculateDaysBetweenTwoDates(start: data.createdAt!, end: data["completionDate"] as! Date)
                completionProgressView.progress = Float(startToCurrent) / Float(startToCompletion)
            }
            
        }
    }
    
    private func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }

    func didTapGoal(_ sender: UITapGestureRecognizer) {
        delegate?.infoCellGoal(self, didTap: data)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style views
        infoBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        progressBackground.layer.cornerRadius = 10
        authorIcon.layer.cornerRadius = authorIcon.frame.height / 2
        descriptionBackground.layer.cornerRadius = 10
        
        // Set up graph
        axisFormatDelegate = self as? IAxisValueFormatter
        days = ["M", "T", "W", "T", "F", "S", "S"]
        
        let xAxis = graphView.xAxis
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()
        
        graphView.notifyDataSetChanged()
        
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapGoal(_:)))
        descriptionBackground.addGestureRecognizer(cellTapGestureRecognizer)
        descriptionBackground.isUserInteractionEnabled = true
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        graphView.chartDescription?.text = ""
        graphView.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
        progressBackground.backgroundColor = graphView.backgroundColor
        
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
