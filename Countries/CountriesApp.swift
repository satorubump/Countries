//
//  CountriesApp.swift
//  Countries
//
//  Created by Satoru Ishii on 4/27/25.
//

import SwiftUI

@main
struct CountriesApp: App {
    var body: some Scene {
        WindowGroup {
            CountriesView()
                .environmentObject(CountriesViewModel.shared)
        }
    }
}
