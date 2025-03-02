//
//  AeonIntelligenceApp.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/25.
//

import SwiftUI

@main
struct AeonIntelligenceApp: App {
    @State private var authState = AuthenticationState()

    var body: some Scene {
        WindowGroup {
            if !authState.isAuthenticated {
                Login()
                    .environment(authState)
            } else {
                ContentView()
                    .environment(authState)
            }
        }
    }
}
