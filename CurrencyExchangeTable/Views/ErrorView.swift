//
//  ErrorView.swift
//  CurrencyExchangeTable
//
//  Created by Vladislav Ralovich on 19.01.2025.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)

            Text("Ошибка загрузки данных")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text("Перезапустите приложение или попробуйте позже.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding()
    }
}
