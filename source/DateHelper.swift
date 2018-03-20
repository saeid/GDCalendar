//
//  DateHelper.swift
//  GDCalendar
//
//  Created by Saeid Basirnia on 3/19/18.
//  Copyright © 2018 Saeid Basirnia. All rights reserved.
//

import Foundation

extension Date{
    var currentCalendar: Calendar{
        var locale: Locale!
        if let localeString = UserDefaults.standard.object(forKey: "current_locale") as? String{
            locale = Locale(identifier: localeString)
        }else{
            locale = Locale.current
        }
        return locale.calendar
    }
    
    var today: Date{
        let comps: DateComponents = currentCalendar.dateComponents([.year, .month, .day], from: self)
        return currentCalendar.date(from: comps)!
    }
    
    var startingDayOfMonth: Int{
        return currentCalendar.component(.weekday, from: self)
    }
    
    var startDayOfMonth: Date{
        return currentCalendar.date(from: currentCalendar.dateComponents([.year, .month], from: currentCalendar.startOfDay(for: self)))!
    }
    
    var endDayOfMonth: Date{
        return currentCalendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDayOfMonth)!
    }
    
    func date(year: Int, month: Int, day: Int) -> Date{
        var comps: DateComponents = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        
        return currentCalendar.date(from: comps)!
    }
    
    var daysIntMonth: Int{
        return currentCalendar.range(of: .day, in: .month, for: self)!.count
    }
    
    var componentsOfDate: (year: Int, month: Int, day: Int){
        let comps = currentCalendar.dateComponents([.year, .month, .day], from: self)
        return (comps.year!, comps.month!, comps.day!)
    }
    
    var nextMonth: Date{
        return currentCalendar.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    var previousMonth: Date{
        return currentCalendar.date(byAdding: DateComponents(month: -1), to: self)!
    }

    var monthName: String{
        let dtFormatter: DateFormatter = DateFormatter()
        dtFormatter.dateFormat = "MMMM"
        
        return dtFormatter.string(from: self)
    }
    
    var dayName: String{
        let dtFormatter: DateFormatter = DateFormatter()
        dtFormatter.dateFormat = "EEEE"
        
        return dtFormatter.string(from: self)
    }
    
    func isToday(date: Date) -> Bool{
        let result = currentCalendar.compare(self, to: date, toGranularity: .day)
        switch result{
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    var daysVeryShort: [String]{
        return currentCalendar.veryShortWeekdaySymbols
    }
    
    var days: [String]{
        return currentCalendar.shortWeekdaySymbols
    }
    
    var months: [String]{
        return currentCalendar.monthSymbols
    }
    
    func add(days: Int) -> Date{
        return currentCalendar.date(byAdding: .day, value: days, to: self)!
    }

    func add(months: Int) -> Date{
        return currentCalendar.date(byAdding: .month, value: months, to: self)!
    }
}
