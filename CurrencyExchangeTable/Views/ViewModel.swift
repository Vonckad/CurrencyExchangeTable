//
//  ViewModel.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 17.01.2025.
//

import SwiftUI
import SwiftData

@Observable
class ViewModel {
    var modelContext: ModelContext
    
    var items: [Item] {
        let descriptor = FetchDescriptor<Item>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadData() async {
        do {
            let fetchedItems = try await NetworkService.shared.getRate()
            
            let existingItems = try modelContext.fetch(FetchDescriptor<Item>())
            for item in existingItems {
                modelContext.delete(item)
            }
            
            for item in fetchedItems {
                modelContext.insert(item)
            }
            
            try modelContext.save()
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }
}
