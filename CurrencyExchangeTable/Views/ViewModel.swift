//
//  ViewModel.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 17.01.2025.
//

import SwiftUI
import SwiftData

@MainActor
class ViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var items: [CurrencyRate] = []
    @Published var errorMessage: String?
    @Published var date: Date?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadItems()
    }

    func loadData() async {
        do {
            let fetchedItems = try await NetworkService.shared.getRate()
            let existingItems = try modelContext.fetch(FetchDescriptor<CurrencyRate>())
            try await deleteItems(existingItems)
            try await insertItems(fetchedItems)
            let currentDate = Date()
            try await saveDate(currentDate)

            self.items = fetchedItems
            self.date = currentDate
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Ошибка загрузки данных: \(error.localizedDescription)"
        }
    }
    
    private func loadItems() {
        do {
            let fetchedItems = try modelContext.fetch(FetchDescriptor<CurrencyRate>())
            self.items = fetchedItems

            if let parentItem = try? modelContext.fetch(FetchDescriptor<ExchangeRateEntry>()).first {
                self.date = parentItem.date
            }

        } catch {
            self.errorMessage = "Ошибка извлечения данных: \(error.localizedDescription)"
        }
    }

    private func saveDate(_ date: Date) async throws {
        let parentItem = ExchangeRateEntry(date: date, items: self.items)
        modelContext.insert(parentItem)
        try modelContext.save()
    }

    private func deleteItems(_ items: [CurrencyRate]) async throws {
        items.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
    
    private func insertItems(_ items: [CurrencyRate]) async throws {
        items.forEach { modelContext.insert($0) }
        try modelContext.save()
    }
}
