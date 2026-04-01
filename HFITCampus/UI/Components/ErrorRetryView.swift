//
//  ErrorRetryView.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import SwiftUI

struct ErrorRetryView: View {
    var message: String = "页面加载失败"
    var onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: onRetry) {
                Text("点击刷新")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview

#Preview {
    ErrorRetryView {
        print("Retry tapped")
    }
}
