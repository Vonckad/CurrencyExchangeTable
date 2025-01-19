//
//  ViewModel.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 17.01.2025.
//

import SwiftUI
import SwiftData

@MainActor
class MainViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var items: [CurrencyRate] = []
    @Published var errorMessage: String?
    @Published var date: Date?
    @Published var isUpdating = false
    private var timer: Timer?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadItems()
    }
    
    deinit {
        timer?.invalidate()
    }

    func loadData() async {
        defer { isUpdating = false }
        guard !isUpdating else { return }
        do {
            isUpdating = true
            let fetchedItems = try await NetworkService.shared.getRate()
            let existingItems = try modelContext.fetch(FetchDescriptor<CurrencyRate>())
            try await deleteItems(existingItems)
            try await insertItems(fetchedItems)
            let currentDate = Date()
            try await saveDate(currentDate)

            self.items = fetchedItems
            self.date = currentDate
            self.errorMessage = nil
            
            startPeriodicDataFetch()
        } catch {
            self.errorMessage = "Ошибка загрузки данных: \(error.localizedDescription)"
        }
    }
    
    func onRefreshButtonTapped() {
        Task { await loadData() }
    }
    
    private func startPeriodicDataFetch() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task { await self.loadData() }
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
