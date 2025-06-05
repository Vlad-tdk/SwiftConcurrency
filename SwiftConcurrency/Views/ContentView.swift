import SwiftUI
import Foundation

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
