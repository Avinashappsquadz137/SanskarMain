//
//  EpProgramViewModel.swift
//  Sanskar
//
//  Created by Warln on 18/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation
import UIKit


class EpProgramViewModel {
    var program: Program
    var titleSting: String
    var startTimeString : String
    var endTimeString: String
    var durationString : String
    
    var scheduleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var dateComponent: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter
    }()
    
    init (program: Program) {
        self.program = program
        self.titleSting = program.title
        self.startTimeString = scheduleDateFormatter.string(from: program.startDate)
        self.endTimeString = scheduleDateFormatter.string(from: program.endDate)
        self.durationString = dateComponent.string(from: program.duration)!
    }
}
