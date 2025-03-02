//
//  Profile.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/26.
//

import SwiftUI

struct Profile: View {
    @Environment(AuthenticationState.self) private var authState
    @State private var showingLogoutAlert = false

    var body: some View {
        VStack {
            // Profile content here

            Button("Logout") {
                showingLogoutAlert = true
            }
            .foregroundStyle(.red)
            .padding()
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }

    private func logout() {
        authState.isAuthenticated = false  // This will trigger the navigation to login
    }
}

#Preview {
    Profile().environment(AuthenticationState(isAuthenticated: true))
}
