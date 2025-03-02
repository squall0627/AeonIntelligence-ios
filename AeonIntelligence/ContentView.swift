//
//  ContentView.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                Chat()
                    .navigationTitle("Chat")
            }
            .tabItem {
                Label("Chat", systemImage: "message.fill")
            }

            NavigationStack {
                KnowledgeWarehouse()
                    .navigationTitle("Knowledge")
            }
            .tabItem {
                Label("Knowledge", systemImage: "books.vertical.fill")
            }

            NavigationStack {
                TranslationTop()
                    .navigationTitle("Translation")
            }
            .tabItem {
                Label("Translation", systemImage: "character.bubble.fill")
            }

            NavigationStack {
                Others()
                    .navigationTitle("Other")
            }
            .tabItem {
                Label("Other", systemImage: "ellipsis.circle.fill")
            }

            NavigationStack {
                Profile()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
