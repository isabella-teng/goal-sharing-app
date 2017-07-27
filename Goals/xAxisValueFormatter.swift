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
    static let days = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]       // xAxis labels
    static let labelCount = days.count                     // count of xAxis labels
    static var indexCount = 0                               // for debug reporting, below
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        let index = Int( value )
        
        // FIXME:   an invalid index is sometimes encountered, report all indices here.
        //          Remove the defensive stuff once the bug is identified.
        xAxisValueFormatter.indexCount += 1

        if index < 0 || index >= xAxisValueFormatter.days.count { return "" }
        return xAxisValueFormatter.days[ index ]
    }
}
