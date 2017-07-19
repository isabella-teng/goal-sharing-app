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
    
<<<<<<< HEAD
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var days: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
=======
    var months: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
>>>>>>> ee2eebf5ede9fce31831c37898813d97a0412b73
        barChartView.delegate = self
        axisFormatDelegate = self as? IAxisValueFormatter
        days = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
        let goalsSet = [1.0, 4.0, 6.0, 3.0, 4.0, 2.0, 4.0]
        let xAxis = barChartView!.xAxis
        xAxis.labelCount = xAxisValueFormatter.labelCount
        xAxis.valueFormatter = xAxisValueFormatter()
        
        setChart(dataPoints: days, values: goalsSet)
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
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Goals Set")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        let sum = values.reduce(0, +)
        let average = sum / 7
        
        
        //Settings for the Bar graph
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        barChartView.scaleYEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = true
        
        // Target or Goal Line
        let lineLimit = ChartLimitLine(limit: average, label: "Avg Goals Per Week")
        barChartView.rightAxis.addLimitLine(lineLimit)
    }
    
<<<<<<< HEAD
=======
    
    
>>>>>>> ee2eebf5ede9fce31831c37898813d97a0412b73
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
<<<<<<< HEAD
    // MARK: - Navigation
     
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
=======
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
>>>>>>> ee2eebf5ede9fce31831c37898813d97a0412b73
    
}
