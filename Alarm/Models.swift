//
//  Models.swift
//  Alarm
//
//  Created by Mike on 2021/1/27.
//

import Foundation

enum WeeksProcedure : Int, CaseIterable, Codable
{
    case 星期日 = 0, 星期一, 星期二, 星期三, 星期四, 星期五 ,星期六
    
    var weeKdays : String
    {
        switch self
        {
        case .星期日:
            return "週日"
        case .星期一:
            return "週一"
        case .星期二:
            return "週二"
        case .星期三:
            return "週三"
        case .星期四:
            return "週四"
        case .星期五:
            return "週五"
        case .星期六:
            return "周六"
        }
    }
}

struct alarmInfo : Codable
{
    var time : Date = Date()
    var label : String = ""
    var isDone : Set<WeeksProcedure> = []
}
