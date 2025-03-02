//
//  AuthenticationState.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/26.
//

import Foundation

@Observable
class AuthenticationState {
    var isAuthenticated: Bool {
        didSet {
            // Clear auth data when logging out
            if !isAuthenticated {
                AuthManager.shared.clearAuth()
            }
        }
    }

    init(isAuthenticated: Bool = AuthManager.shared.isAuthenticated) {
        self.isAuthenticated = isAuthenticated
    }
}
