//
//  Date+Time.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation

extension Date {
    var timeOrDaySinceNow: String {
        let calendar = Calendar.current
        let now = Date()
        
        let diffComponents = calendar.dateComponents([.day, .hour], from: self, to: now)
        
        if let days = diffComponents.day, days > 0 {
            return "\(days)d"
        } else if let hours = diffComponents.hour, hours > 0 {
            return "\(hours)h"
        } else {
            let minutesComponents = calendar.dateComponents([.minute], from: self, to: now)
            if let minutes = minutesComponents.minute, minutes > 0 {
                return "\(minutes)m"
            } else {
                return "now"
            }
        }
    }
}
