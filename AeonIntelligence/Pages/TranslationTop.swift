//
//  TranslationTop.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/27.
//

import SwiftUI

struct TranslationTop: View {
    var body: some View {
        List {
            NavigationLink {
                TextTranslation()
            } label: {
                Label("Text", systemImage: "text.alignleft")
            }

            NavigationLink {
                FileTranslation()
            } label: {
                Label("File", systemImage: "doc.fill")
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    TranslationTop()
}
