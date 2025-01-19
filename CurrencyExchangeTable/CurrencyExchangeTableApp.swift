//
//  CurrencyExchangeTableApp.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 16.01.2025.
//

import SwiftUI
import SwiftData

@main
struct CurrencyExchangeTableApp: App {
    var sharedModelContainer: ModelContainer? = {
        let schema = Schema( [ExchangeRateEntry.self] )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try? ModelContainer(for: schema, configurations: [modelConfiguration])
    }()

    var body: some Scene {
        WindowGroup {
            if let modelContainer = sharedModelContainer {
                MainView(modelContext: modelContainer.mainContext)
                    .modelContainer(modelContainer)
            } else {
                ErrorView()
            }
        }
    }
}
