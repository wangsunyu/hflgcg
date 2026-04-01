//
//  LoadingView.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import SwiftUI

struct LoadingView: View {
    var message: String = "加载中..."

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.2)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview

#Preview {
    LoadingView()
}
