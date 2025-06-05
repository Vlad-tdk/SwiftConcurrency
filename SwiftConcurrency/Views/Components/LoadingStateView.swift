//
//  LoadingStateView.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import SwiftUI

/// Компонент для отображения состояния загрузки
struct LoadingStateView: View {
    let state: LoadingState
    
    var body: some View {
        Group {
            switch state {
            case .idle:
                EmptyView()
                
            case .loading:
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Загрузка данных...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
            case .loaded:
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Данные загружены")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
            case .error(let message):
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Ошибка: \(message)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding()
            }
        }
    }
}
