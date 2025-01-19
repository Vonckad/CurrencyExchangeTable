//
//  NetworkService.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 17.01.2025.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func getRate() async throws -> [CurrencyRate] {
        let apiKey = ""
        let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CurrencyDTO.self, from: data).data.map { CurrencyRate(currency: $0.key, rate: $0.value) }
    }
}
