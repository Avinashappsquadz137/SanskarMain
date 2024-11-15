//
//  EpProgram.swift
//  Sanskar
//
//  Created by Warln on 18/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation

struct Schedule {
    var start: TimeInterval = 0
    var end: TimeInterval = 0
}

class Program: CustomStringConvertible {
    
    var title: String
    var schedule: Schedule
    var startDate: Date{
        return Date(timeIntervalSince1970: TimeInterval(self.schedule.start))
    }
    var endDate: Date{
        return Date(timeIntervalSince1970: TimeInterval(self.schedule.end))
    }
    var duration: TimeInterval {
        return self.endDate.addingTimeInterval(-self.schedule.start).timeIntervalSince1970
    }
    init (title: String, schedule:Schedule){
        self.title = title
        self.schedule = schedule
    }
    var description: String {
        return "\(self.title) - \(self.startDate) - \(self.endDate)"
    }
    
    
}
