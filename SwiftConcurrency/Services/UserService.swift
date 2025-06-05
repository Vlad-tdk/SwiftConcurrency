//
//  UserService.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import Foundation

// MARK: - Business Logic Layer

/// Сервис для управления данными пользователей
/// Демонстрирует структурированную конкурентность с TaskGroup
@MainActor
class UserService: ObservableObject {
    @Published var users: [User] = []
    @Published var userPosts: [Int: [Post]] = [:]
    @Published var loadingState: LoadingState = .idle
    @Published var requestCount: Int = 0
    
    private let networkManager = NetworkManager()
    private var loadingTask: Task<Void, Never>?
    
    /// Загружает пользователей и их посты параллельно
    /// Демонстрирует TaskGroup для структурированной конкурентности
    func loadUsersWithPosts() {
        // Отменяем предыдущую задачу если она выполняется
        loadingTask?.cancel()
        
        loadingTask = Task {
            await updateLoadingState(.loading)
            
            do {
                // Сначала загружаем пользователей
                let fetchedUsers = try await networkManager.fetchUsers()
                await updateUsers(fetchedUsers)
                
                // Затем параллельно загружаем посты для всех пользователей
                await loadPostsForAllUsers(fetchedUsers)
                
                await updateLoadingState(.loaded)
                
            } catch is CancellationError {
                print("Загрузка отменена пользователем.")
                await updateLoadingState(.idle)
            } catch {
                await updateLoadingState(.error(error.localizedDescription))
            }
            
            // Обновляем счетчик запросов
            let count = await networkManager.getRequestCount()
            await updateRequestCount(count)
        }
    }
    
    /// Загружает посты для всех пользователей параллельно
    /// Демонстрирует TaskGroup для параллельного выполнения задач
    private func loadPostsForAllUsers(_ users: [User]) async {
        await withTaskGroup(of: (Int, [Post]?).self) { group in
            // Добавляем задачи для каждого пользователя в группу
            for user in users {
                group.addTask { [weak self] in
                    do {
                        let posts = try await self?.networkManager.fetchPosts(for: user.id) ?? []
                        return (user.id, posts)
                    } catch {
                        print("Ошибка загрузки постов для пользователя \(user.id): \(error)")
                        return (user.id, nil)
                    }
                }
            }
            
            // Собираем результаты из всех задач
            var postsDict: [Int: [Post]] = [:]
            for await (userId, posts) in group {
                if let posts = posts {
                    postsDict[userId] = posts
                }
            }
            
            await updateUserPosts(postsDict)
        }
    }
    
    /// Отменяет текущую загрузку (демонстрирует cooperative cancellation)
    func cancelLoading() {
        loadingTask?.cancel()
        loadingTask = nil
        loadingState = .idle
    }
    
    // MARK: - Private Methods (MainActor изолированные)
    
    private func updateUsers(_ users: [User]) async {
        self.users = users
    }
    
    private func updateUserPosts(_ posts: [Int: [Post]]) async {
        self.userPosts = posts
    }
    
    private func updateLoadingState(_ state: LoadingState) async {
        self.loadingState = state
    }
    
    private func updateRequestCount(_ count: Int) async {
        self.requestCount = count
    }
}
