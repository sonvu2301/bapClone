//
//  Date.swift
//  BAPMobile
//
//  Created by Emcee on 12/18/20.
//

import Foundation
import UIKit

extension Date {
    
    func millisecToDate(time: Int) -> String {
        let dateVar = Date.init(timeIntervalSince1970: Double(time - TimeZone.vn.number))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: dateVar)
    }
    
    func millisecToHourMinute(time: Int) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        
        // return formated string
        return String(format: "%02i:%02i", hour, minute)
    }
    
    func millisecToHourMinuteWithText(time: Int) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        
        // return formated string
        return String(format: "%02i giờ : %02i phút", hour, minute)
    }
    
    func millisecToMinute(time: Int) -> String {
        let dateVar = Date.init(timeIntervalSince1970: Double(time - TimeZone.vn.number))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: dateVar)
    }
    
    func millisecToHourDate(time: Int) -> String {
        let dateVar = Date.init(timeIntervalSince1970: Double(time - TimeZone.vn.number))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd/MM/yyyy"
        return dateFormatter.string(from: dateVar)
    }
    
    func millisecToDateHour(time: Int) -> String {
        let dateVar = Date.init(timeIntervalSince1970: Double(time - TimeZone.vn.number))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm "
        return dateFormatter.string(from: dateVar)
    }
    
    func millisecToDateHourSaved(time: Int) -> String {
        let dateVar = Date.init(timeIntervalSince1970: Double(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm "
        return dateFormatter.string(from: dateVar)
    }
    
    func dateToDayMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: date)
    }
    
    func getHourMinute(time: Int) -> String {
        let dateVar = Date.init(timeIntervalSince1970: Double(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateVar)
    }
    
    
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDays() -> [Date] {
        var days = [Date]()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count {
            days.append(day)
            day.addDays(n: 1)
        }
        return days
    }
    
    func dayOfWeek(date: Date) -> String {
        let number = Calendar.current.dateComponents([.weekday], from: date).weekday
        switch number {
        case 1:
            return "CN"
        case 2:
            return "Thứ 2"
        case 3:
            return "Thứ 3"
        case 4:
            return "Thứ 4"
        case 5:
            return "Thứ 5"
        case 6:
            return "Thứ 6"
        case 7:
            return "Thứ 7"
        default:
            return ""
        }
    }
    
    func getDates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func getWeekDate(isNextWeek: Bool, date: Date) -> [Date] {
        let value = isNextWeek == true ? 1 : -1
        let calendar = Calendar.current
        let dateCompare = calendar.date(byAdding: .weekOfYear, value: value, to: date) ?? Date()
        if isNextWeek {
            var dates = getDates(from: date, to: dateCompare)
            dates.removeFirst()
            return dates
        } else {
            var dates = getDates(from: dateCompare, to: date)
            dates.removeLast()
            return dates
        }
    }
    
    func getYear(start: Int, end: Int) -> [Int] {
        var years = [Int]()
        for i in start...end {
            years.append(i)
        }
        return years
    }
}


extension String {
    func stringToIntDate() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: self)
        
        return Int(date?.timeIntervalSince1970 ?? 0) + TimeZone.vn.number
    }
    
    func secondFromString() -> Int {
        let components: Array = self.components(separatedBy: ":")
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[1]) ?? 0
        let time = (hours * 60 * 60) + (minutes * 60)
        
        return time
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
