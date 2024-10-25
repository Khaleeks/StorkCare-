//  StorkCare_App.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI

@main
struct StorkCarePlusApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                IntroductionPage() // Starts from the Introduction page
            }
        }
    }
}
