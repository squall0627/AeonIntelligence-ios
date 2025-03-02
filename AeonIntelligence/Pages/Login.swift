//
//  Login.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/26.
//

import SwiftUI

struct Login: View {
    @Environment(AuthenticationState.self) private var authState
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    let gradientColors: [Color] = [.gradientTop, .gradientBottom]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title
                Text("Aeon Intelligence")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 30)

                ZStack {
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundStyle(.white)

                    Image(systemName: "sparkles")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.yellow)
                        .offset(x: 30, y: -30)
                }
                .padding(.bottom, 30)

                // Username field
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding(.horizontal)

                // Password field
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                // Login button
                Button(action: login) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Login")
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(.tint)
                .cornerRadius(8)
                .padding(.horizontal)
                .disabled(isLoading || username.isEmpty || password.isEmpty)

                Spacer()
            }
            .padding(.top, 50)
            .background(Gradient(colors: gradientColors))
        }
    }

    struct LoginResponse: Decodable {
        let accessToken: String
        let tokenType: String

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
        }
    }

    private func login() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        // Create temporary API client for login
        let apiClient = APIClient(authState: authState)

        Task {
            do {
                let response: LoginResponse = try await apiClient.post(
                    path: "/api/auth/login_for_access_token",
                    body: ["username": username, "password": password],
                    contentType: .form,
                    needAuth: false
                )

                await MainActor.run {
                    // Save authentication info
                    AuthManager.shared.token = response.accessToken

                    // Update UI
                    authState.isAuthenticated = true
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage =
                        "Login failed. Please check your credentials."
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    Login().environment(AuthenticationState())
}
