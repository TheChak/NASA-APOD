//
//  DateHelper.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 05/11/2021.
//

import Foundation

class DateHelper {
    
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
