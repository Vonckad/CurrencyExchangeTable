//
//  ContentView.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 16.01.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ViewModel?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel?.items ?? [], id: \.id) { item in
                    HStack {
                        Text(item.currency)
                        Spacer()
                        Text("\(item.rate)")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Currency Exchange")
        }
        .searchable(text: $searchText/*, placement: .toolbar*/) {
            ForEach(searchResults, id: \.self) { item in
                HStack {
                    Text(item.currency)
                    Spacer()
                    Text("\(item.rate)")
                }
            }
        }
        .task {
            await viewModel?.loadData()
        }
        .onAppear {
            viewModel = ViewModel(modelContext: modelContext)
        }
    }
    
    var searchResults: [Item] {
            if searchText.isEmpty {
                return viewModel?.items ?? []
            } else {
                return viewModel?.items.filter { $0.currency.contains(searchText) } ?? []
            }
        }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
