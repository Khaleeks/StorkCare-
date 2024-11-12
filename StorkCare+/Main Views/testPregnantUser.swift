//
//  testPregnantUser.swift
//  StorkCare+
//
//  Created by Aribah Zaman on 12/11/2024.
//

import SwiftUI
import Foundation

class testPregnantUser {
    var pregnancyStartDate: Date = Date()
    init (year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let calendar = Calendar.current
        self.pregnancyStartDate = calendar.date(from: components)!
    }
    func getDate() -> Date? {
        return self.pregnancyStartDate
    }
}
