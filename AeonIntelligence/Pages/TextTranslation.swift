//
//  TextTranslation.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/25.
//

import SwiftUI

struct TextTranslation: View {
    @Environment(AuthenticationState.self) private var authState
    @State private var sourceText = ""
    @State private var translationResult = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTranslation: TranslationType?

    var body: some View {
        VStack(spacing: 20) {

            // Source text input
            TextEditor(text: $sourceText)
                .frame(maxHeight: 200)
                .textFieldStyle(.roundedBorder)
                .border(Color.gray)
                .disabled(isLoading)

            //            HStack {
            //                VStack {
            //                    // jaToZh Button
            //                    Button(TranslationType.jaToZh.buttonText) {
            //                        translateText(taskId: TranslationType.jaToZh.taskId)
            //                    }
            //                    .foregroundColor(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .padding(5)
            //                    .background(
            //                        .tint,
            //                        in: RoundedRectangle(cornerRadius: 5))
            //
            //                    // jaToEn Button
            //                    Button(TranslationType.jaToEn.buttonText) {
            //                        translateText(taskId: TranslationType.jaToEn.taskId)
            //                    }
            //                    .foregroundColor(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .padding(5)
            //                    .background(
            //                        .tint,
            //                        in: RoundedRectangle(cornerRadius: 5))
            //                }
            //                VStack {
            //                    // zhToJa Button
            //                    Button(TranslationType.zhToJa.buttonText) {
            //                        translateText(taskId: TranslationType.zhToJa.taskId)
            //                    }
            //                    .foregroundColor(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .padding(5)
            //                    .background(
            //                        .tint,
            //                        in: RoundedRectangle(cornerRadius: 5))
            //
            //                    // zhToEn Button
            //                    Button(TranslationType.zhToEn.buttonText) {
            //                        translateText(taskId: TranslationType.zhToEn.taskId)
            //                    }
            //                    .foregroundColor(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .padding(5)
            //                    .background(
            //                        .tint,
            //                        in: RoundedRectangle(cornerRadius: 5))
            //                }
            //                VStack {
            //                    // enToJa Button
            //                    Button(TranslationType.enToJa.buttonText) {
            //                        translateText(taskId: TranslationType.enToJa.taskId)
            //                    }
            //                    .foregroundColor(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .padding(5)
            //                    .background(
            //                        .tint,
            //                        in: RoundedRectangle(cornerRadius: 5))
            //
            //                    // enToZh Button
            //                    Button(TranslationType.enToZh.buttonText) {
            //                        translateText(taskId: TranslationType.enToZh.taskId)
            //                    }
            //                    .foregroundColor(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .padding(5)
            //                    .background(
            //                        .tint,
            //                        in: RoundedRectangle(cornerRadius: 5))
            //                }
            //            }
            //            .disabled(isLoading)
            // Translation Menu Button
            Menu {
                ForEach(TranslationType.allCases, id: \.taskId) { type in
                    Button(type.buttonText) {
                        selectedTranslation = type
                        translateText(taskId: type.taskId)
                    }
                }
            } label: {
                HStack {
                    Text(
                        selectedTranslation?.buttonText ?? "Translate")
                    Image(systemName: "chevron.up.chevron.down")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.tint, in: RoundedRectangle(cornerRadius: 8))
            }
            .disabled(isLoading)

            // Translation result with copy button
            HStack {
                // Translation result
                TextEditor(text: $translationResult)
                    .frame(maxHeight: .infinity)
                    .textFieldStyle(.roundedBorder)
                    // .border(Color.gray)
                    .disabled(true)

                VStack {
                    // Copy Button
                    Button(action: {
                        UIPasteboard.general.string = translationResult
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .disabled(translationResult.isEmpty || isLoading)

                    Spacer()
                }

            }

            if isLoading {
                LoadingOverlay()
            }

            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding()

        Spacer()
    }

    private func translateText(taskId: String) {
        isLoading = true

        translationResult = ""
        errorMessage = nil

        let apiClient = APIClient(authState: authState)

        Task {
            do {
                try await apiClient.postStreaming(
                    path: "/api/translation/text/\(taskId)",
                    body: ["text": sourceText],
                    contentType: .json,
                    needAuth: true
                ) { str in
                    // Update UI on the main thread
                    translationResult += str
                }

                isLoading = false
            } catch {
                errorMessage =
                    "Translation failed. \r\nError:\(error)"
                isLoading = false
            }
        }
    }
}

#Preview {
    TextTranslation().environment(AuthenticationState())
}
