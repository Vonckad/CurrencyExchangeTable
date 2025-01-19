//
//  DateExtension.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 19.01.2025.
//

import Foundation

extension Date {
   func getFormattedDate() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd.MM.yy HH:mm"
        return dateformat.string(from: self)
    }
}
