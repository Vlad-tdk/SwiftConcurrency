//
//  LoadingState.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import Foundation

/// Состояние загрузки для UI
enum LoadingState: Sendable, Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
