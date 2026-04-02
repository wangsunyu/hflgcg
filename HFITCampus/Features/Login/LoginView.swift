//
//  LoginView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
    }

    var body: some View {
        ZStack {
            contentView

            if viewModel.isLoggingIn {
                loginOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadAppIdIfNeeded()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isPreparing && viewModel.loginURL == nil {
            LoadingView(message: "登录环境准备中")
        } else if viewModel.webLoadFailed || viewModel.loginURL == nil {
            ErrorRetryView(message: viewModel.errorMessage ?? "登录页面加载失败，请重试") {
                viewModel.retry()
            }
        } else if let loginURL = viewModel.loginURL {
            ZStack(alignment: .top) {
                WebView(
                    url: loginURL,
                    progress: $viewModel.progress,
                    onWebViewCreated: { webView in
                        viewModel.bindWebView(webView)
                    },
                    onURLChange: { url in
                        viewModel.handleURLChange(url)
                    },
                    onFinish: {
                        viewModel.handleWebFinish()
                    },
                    onFail: { error in
                        viewModel.handleWebFail(error)
                    }
                )

                if viewModel.progress > 0 && viewModel.progress < 1 && !viewModel.webLoadFailed {
                    ProgressView(value: viewModel.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
            }
            .ignoresSafeArea()
        }
    }

    private var loginOverlay: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("登录中...")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
            )
        }
    }
}

#Preview {
    LoginView(appState: AppState())
}
