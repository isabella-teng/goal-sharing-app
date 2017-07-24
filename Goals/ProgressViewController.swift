//
//  ProgressViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/17/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Charts


class ProgressViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChart(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        let alertController = UIAlertController(title: "Saved", message: "Your chart has been successfully saved to your camera roll!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var days: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        axisFormatDelegate = self as? IAxisValueFormatter
        days = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
        let updatesMade = [1.0, 4.0, 6.0, 3.0, 4.0, 2.0, 4.0]
        
        //Sets up X Axis labels
        let xAxis = barChartView!.xAxis
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()
        
        setChart(dataPoints: days, values: updatesMade)
        barChartView.notifyDataSetChanged()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = ""
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Updates Made")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        let sum = values.reduce(0, +)
        let average = sum / 7
        let average1 = average + 1.02
        
        
        
        //Settings for the Bar graph
        chartDataSet.colors = [UIColor(red: 255/255, green: 95/255, blue: 107/255, alpha: 1)]
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        barChartView.scaleYEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.legend.enabled = true
        
        
        // Updates/Average Limit Lines
        let averageEstimate = ChartLimitLine(limit: average, label: "Est. Updates Per Week")
        averageEstimate.valueFont = UIFont(name: "Verdana", size: 10.0)!
        averageEstimate.lineColor = UIColor.gray
        barChartView.rightAxis.addLimitLine(averageEstimate)
        averageEstimate.labelPosition = .leftBottom
        
        let actualAverage = ChartLimitLine(limit: average1, label: "Your average")
        actualAverage.valueFont = UIFont(name: "Verdana", size: 10.0)!
        if average1 > average {
            actualAverage.lineColor = UIColor.green
            barChartView.rightAxis.addLimitLine(actualAverage)
        } else if average1 < average {
            actualAverage.lineColor = UIColor.red
            barChartView.rightAxis.addLimitLine(actualAverage)
        } else if average1 == average {
            actualAverage.lineColor = UIColor.green
            barChartView.rightAxis.addLimitLine(actualAverage)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
