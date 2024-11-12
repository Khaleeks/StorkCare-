//
//  testPregnantUser.swift
//  StorkCare+
//
//  Created by Aribah Zaman on 12/11/2024.
//

import SwiftUI
import Foundation

struct testPregnantUser {
    var pregnancyStartDate: Date = Date()
    init(date: Date) {
        self.pregnancyStartDate = date
    }
    func getDate() -> Date? {
        return self.pregnancyStartDate
    }
}


