//
//  MainView.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 16.01.2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: MainViewModel
    @State private var searchText = ""
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            List { list(viewModel.items) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Курс валют")
                            .font(.headline)
                        Text("данные на: \(viewModel.date?.getFormattedDate() ?? "" )")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isUpdating {
                        ProgressView().tint(.blue)
                    } else {
                        Button {
                            viewModel.onRefreshButtonTapped()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Поиск") {
                if searchResults.isEmpty {
                    Text("Результатов нет").foregroundColor(.gray)
                } else {
                    list(searchResults)
                }
            }
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .autocorrectionDisabled()
        }
        .task { await viewModel.loadData() }
        .alert(isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Alert(
                title: Text("Ошибка"),
                message: Text( viewModel.errorMessage ?? "Неизвестная ошибка"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func list(_ items: [CurrencyRate]) -> some View {
        ForEach(items, id: \.id) { item in
            HStack {
                Text(currencyFlags["USD"] ?? "")
                Text("1 USD")
                Spacer()
                Text("\(currencyFlags[item.currency] ?? "")")
                Text("\(String(format: "%.2f", item.rate))").frame(width: UIScreen.main.bounds.width / 5, alignment: .leading).padding(.horizontal, 8)
                Text("\(item.currency)").frame(width: 40, alignment: .leading)
            }
        }
    }
    
    private var searchResults: [CurrencyRate] {
        if searchText.isEmpty {
            return viewModel.items
        } else {
            return viewModel.items.filter { $0.currency.lowercased().contains(searchText.lowercased()) }
        }
    }
}
