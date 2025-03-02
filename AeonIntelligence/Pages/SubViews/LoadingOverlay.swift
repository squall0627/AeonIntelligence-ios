//
//  LoadingOverlay.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/26.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}

#Preview {
    LoadingOverlay()
}
