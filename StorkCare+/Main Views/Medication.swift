//
//  Medication.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/25/24.
//

import Foundation

struct Medication: Identifiable {
    let id = UUID() // Unique identifier
    var name: String
    var reminderTime: Date
}
