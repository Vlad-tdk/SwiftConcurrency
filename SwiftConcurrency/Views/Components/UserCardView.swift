//
//  UserCardView.swift
//  SwiftConcurrency
//
//  Created by Vladimir Martemianov on 5. 6. 2025..
//

import SwiftUI

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
