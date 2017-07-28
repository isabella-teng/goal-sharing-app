//
//  xAxisValueFormatter.swift
//  Goals
//
//  Created by Josh Olumese on 7/19/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Charts

class xAxisValueFormatter: NSObject, IAxisValueFormatter {
    static let days = ["M", "Tu", "W", "Th", "F", "Sa", "Su"]     // xAxis labels
    static let labelCount = days.count                   // count of xAxis labels
    static var indexCount = 0                              // for debug reporting, below
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        var index = 0
        
        if value == 0.0 {
            index = 0
        } else if value == 0.9 {
            index = 1
        } else if value == 1.8 {
            index = 2
        } else if value == 2.7 {
            index = 3
        } else if value == 3.6 {
            index = 4
        } else if value == 4.5 {
            index = 5
        } else if value == 5.4 {
            index = 6
        }
        
        // FIXME:   an invalid index is sometimes encountered, report all indices here.
        //          Remove the defensive stuff once the bug is identified.
        xAxisValueFormatter.indexCount += 1

        if index < 0 || index >= xAxisValueFormatter.days.count
        { return "" }
        //print(index)
        //print(xAxisValueFormatter.days[ index ])
        return xAxisValueFormatter.days[ index ]
    }
}
