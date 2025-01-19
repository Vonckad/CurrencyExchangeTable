//
//  ExchangeRateEntry.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 19.01.2025.
//

import Foundation
import SwiftData

@Model
final class ExchangeRateEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    @Relationship var items: [CurrencyRate]

    init(id: UUID = UUID(), date: Date, items: [CurrencyRate]) {
        self.id = id
        self.date = date
        self.items = items
    }
}
