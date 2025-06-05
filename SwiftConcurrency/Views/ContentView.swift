import SwiftUI
import Foundation



// MARK: - UI Components

/// Компонент для отображения пользователя
struct UserCardView: View {
    let user: User
    let posts: [Post]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(user.avatar)
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(user.email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(posts.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
            
            if !posts.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(posts.prefix(2)) { post in
                        Text(post.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    if posts.count > 2 {
                        Text("и еще \(posts.count - 2)...")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

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

// MARK: - Main View

/// Главный экран приложения
/// Демонстрирует @MainActor и интеграцию с UI
struct ContentView: View {
    @StateObject private var userService = UserService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                headerView
                
                LoadingStateView(state: userService.loadingState)
                
                userListView
                
                Spacer()
                
                actionButtonsView
            }
            .padding()
            .navigationTitle("Swift Concurrency Demo")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Демонстрация Swift Concurrency")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("async/await • TaskGroup • Actors • @MainActor")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if userService.requestCount > 0 {
                Text("Выполнено сетевых запросов: \(userService.requestCount)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var userListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(userService.users) { user in
                    let posts = userService.userPosts[user.id] ?? []
                    UserCardView(user: user, posts: posts)
                }
            }
        }
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: 12) {
            Button(action: {
                userService.loadUsersWithPosts()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Загрузить данные")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(userService.loadingState == .loading)
            
            Button(action: {
                userService.cancelLoading()
            }) {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Отменить")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(userService.loadingState != .loading)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
