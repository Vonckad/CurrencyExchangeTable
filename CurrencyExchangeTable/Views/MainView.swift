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
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    HStack {
                        Text(item.currency)
                        Spacer()
                        Text("\(item.rate)")
                    }
                }
            }
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
                    Button {
                        Task { await viewModel.loadData() }
                    } label: {
                        Text("Обновить")
                    }
                }
            }
        }
        .searchable(text: $searchText) {
            ForEach(searchResults, id: \.self) { item in
                HStack {
                    Text(item.currency)
                    Spacer()
                    Text("\(item.rate)")
                }
            }
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
    
    private var searchResults: [CurrencyRate] {
        if searchText.isEmpty {
            return viewModel.items
        } else {
            return viewModel.items.filter { $0.currency.contains(searchText) }
        }
    }
}
