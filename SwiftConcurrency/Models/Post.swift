//
//  Post.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import Foundation

/// Модель поста, демонстрирующая Sendable протокол
struct Post: Identifiable, Codable, Sendable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
