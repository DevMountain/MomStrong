//
//  CalenderHelper.swift
//  MomStrong
//
//  Created by DevMountain on 12/9/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation


class CalendarHelper{
    
    var dateComponentsNow: DateComponents{
        return Calendar.current.dateComponents([.day, .month, .year, .weekOfYear, .hour], from: Date())
    }
    
    var currentDay: Int {
        return dateComponentsNow.day ?? 0
    }
    
    var currentMonth: Int{
        return dateComponentsNow.month ?? 0
    }
    
    var currentMonthName: String{
        return Calendar.current.monthSymbols[currentMonth - 1]
    }
    
    var currentYear: Int{
        return dateComponentsNow.year ?? 0
    }
    
    var oneWeekAgo: Date{
        return Date(timeInterval: -60*60*24*7, since: Date())
    }
    
    var twoWeeksAgo: Date {
        return Date(timeIntervalSinceNow: -60*60*24*7*2)
    }
    
    static var oneYearFromNow: Date {
        return Date(timeIntervalSinceNow: 60*60*24*7*52)
    }
    
    static var oneYearAgo: Date {
        return Date(timeIntervalSinceNow: -60*60*24*7*52)
    }
    
    var numberOfDaysInCurrentMonth: Int{
        return numberOfDaysIn(month: dateComponentsNow.month ?? 0)
    }
    
    func monthName(for month: Int) -> String{
        return Calendar.current.monthSymbols[month - 1]
    }
    
    func monthName(for date: Date) -> String {
        let monthComponents = Calendar.current.dateComponents([.month], from: date)
        return monthName(for: monthComponents.month!)
    }
    
    func year(for date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date).year!
    }
    
    func numberOfDaysIn(month: Int) -> Int{
        let year = Calendar.current.dateComponents([.year], from: Date()).year
        let monthDateComponents = DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, era: nil, year: year, month: month, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        guard let monthDate = Calendar.current.date(from: monthDateComponents) else {return 0}
        
        return Calendar.current.range(of: .day, in: .month, for: monthDate)?.count ?? 0
    }
}

extension DateComponents {
    
    func matches(components: DateComponents, for parts: Set<Calendar.Component>) -> Bool {
        for part in parts {
            if components.value(for: part) != self.value(for: part) {
                return false
            }
        }
        return true
    }
}
