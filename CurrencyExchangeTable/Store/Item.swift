//
//  Item.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 16.01.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    @Attribute(.unique) var id: UUID
    var currency: String
    var rate: Float
    
    init(id: UUID = UUID(), currency: String, rate: Float) {
        self.id = id
        self.currency = currency
        self.rate = rate
    }
}
