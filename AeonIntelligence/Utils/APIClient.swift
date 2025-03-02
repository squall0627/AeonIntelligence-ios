//
//  APIClient.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case authenticationError
    case networkError(Error)
    case invalidResponse
    case serverError(Int)
    case decodingError(Error)
}

class APIClient {
    private let authState: AuthenticationState

    private let baseURL: String = Configuration.shared.apiBaseUrl

    init(authState: AuthenticationState) {
        self.authState = authState
    }

    private func createRequest(
        path: String, method: String, body: [String: Any]? = nil,
        contentType: ContentType = .json,
        needAuth: Bool = true
    ) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        if needAuth {
            guard let token: String = AuthManager.shared.token else {
                throw APIError.authenticationError
            }
            request.setValue(
                "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.setValue(contentType.type, forHTTPHeaderField: "Content-Type")

        if contentType == .form {

            let formData = body ?? [:]
            // Convert form data to url-encoded string
            let formBody =
                formData
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                ?? ""

            request.httpBody = formBody.data(using: .utf8)
        } else {

            if let body = body {
                request.httpBody = try JSONSerialization.data(
                    withJSONObject: body)
            }
        }

        return request
    }

    private func handleResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse
        else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode)
        else {
            switch httpResponse.statusCode {
            case 401:
                throw APIError.authenticationError
            case 403:
                authState.isAuthenticated = false
                throw APIError.authenticationError
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
        }
    }

    // GET request returning JSON
    func get<T: Decodable>(
        path: String, contentType: ContentType = .json, needAuth: Bool = true
    ) async throws
        -> T
    {
        let request = try createRequest(
            path: path, method: "GET", contentType: contentType,
            needAuth: needAuth)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response: response)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    //    // GET request with streaming response
    //    func getStreaming(
    //        path: String, contentType: ContentType = .json, needAuth: Bool = true,
    //        onReceive: @escaping (String) -> Void
    //    )
    //        async throws
    //    {
    //        let request = try createRequest(
    //            path: path, method: "GET", contentType: contentType,
    //            needAuth: needAuth)
    //
    //        let (bytes, response) = try await URLSession.shared.bytes(for: request)
    //
    //        guard let httpResponse = response as? HTTPURLResponse,
    //            (200...299).contains(httpResponse.statusCode)
    //        else {
    //            throw APIError.invalidResponse
    //        }
    //
    //        for try await line in bytes.lines {
    //            onReceive(line)
    //        }
    //    }

    // POST request returning JSON
    func post<T: Decodable>(
        path: String, body: [String: Any], contentType: ContentType = .json,
        needAuth: Bool = true
    ) async throws -> T {
        let request = try createRequest(
            path: path, method: "POST", body: body, contentType: contentType,
            needAuth: needAuth)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response: response)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // POST request with streaming response
    func postStreaming(
        path: String, body: [String: Any], contentType: ContentType = .json,
        needAuth: Bool = true,
        onReceive: @escaping (String) -> Void
    ) async throws {
        let body = body.merging(["is_stream": true]) { (current, new) in current
        }

        let request = try createRequest(
            path: path, method: "POST", body: body, contentType: contentType,
            needAuth: needAuth)

        let (bytes, response) = try await URLSession.shared.bytes(for: request)

        try handleResponse(response: response)

        for try await chr in bytes.characters {
            onReceive(String(chr))
        }
    }
}
