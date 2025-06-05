//
//  User.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import Foundation

/// Модель пользователя, соответствующая протоколу Sendable для безопасной передачи между акторами
struct User: Identifiable, Codable, Sendable {
    let id: Int
    let name: String
    let email: String
    let avatar: String
}
