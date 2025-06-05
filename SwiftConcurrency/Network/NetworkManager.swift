//
//  NetworkManager.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import Foundation

// MARK: - Network Layer

/// Актор для безопасного управления сетевыми запросами
/// Демонстрирует использование Actor для thread-safe операций
actor NetworkManager {
    private var requestCount = 0
    private let session = URLSession.shared
    
    /// Увеличивает счетчик запросов (демонстрирует изменение состояния в акторе)
    private func incrementRequestCount() {
        requestCount += 1
        print("Network request #\(requestCount)")
    }
    
    /// Получает список пользователей
    /// Демонстрирует async/await и обработку ошибок
    func fetchUsers() async throws -> [User] {
        incrementRequestCount()
        
        // Симуляция API вызова
        try await Task.sleep(for: .seconds(1))
        
        // Имитация данных (в реальном приложении это был бы HTTP запрос)
        let mockUsers = [
            User(id: 1, name: "Алексей Иванов", email: "alex@example.com", avatar: "👨‍💻"),
            User(id: 2, name: "Мария Петрова", email: "maria@example.com", avatar: "👩‍🎨"),
            User(id: 3, name: "Дмитрий Сидоров", email: "dmitry@example.com", avatar: "👨‍🔬")
        ]
        
        return mockUsers
    }
    
    /// Получает посты для конкретного пользователя
    func fetchPosts(for userId: Int) async throws -> [Post] {
        incrementRequestCount()
        
        try await Task.sleep(for: .milliseconds(500))
        
        // Симуляция постов пользователя
        let mockPosts = (1...3).map { postId in
            Post(
                id: postId,
                userId: userId,
                title: "Пост #\(postId) от пользователя \(userId)",
                body: "Содержимое поста номер \(postId). Это демонстрационный контент."
            )
        }
        
        return mockPosts
    }
    
    /// Получает количество выполненных запросов
    func getRequestCount() async -> Int {
        return requestCount
    }
}
