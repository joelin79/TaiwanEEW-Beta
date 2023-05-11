//
//  TimeRange.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/4/11.
//

import Foundation
enum TimeRange: String, CaseIterable, Identifiable, Codable{
    case week, twoweek, month, sixmonth, year, all
    var id: Self { self }
    
    func getDisplayName() -> String {
        switch self {
        case .week:
            return "7天 7 Days"
        case .twoweek:
            return "兩週 2 weeks"
        case .month:
            return "一個月 1 month"
        case .sixmonth:
            return "六個月 6 months"
        case .year:
            return "一年 1 year"
        case .all:
            return "全部 All"
        }
    }
    
    func getDays() -> Int {
        switch self {
        case .week:
            return 7
        case .twoweek:
            return 14
        case .month:
            return 31
        case .sixmonth:
            return 183
        case .year:
            return 365
        case .all:
            return 9999
        }
    }
}
