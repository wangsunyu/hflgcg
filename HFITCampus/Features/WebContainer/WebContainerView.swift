//
//  WebContainerView.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import SwiftUI
import WebKit
import Combine

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Web Container View

struct WebContainerView: View {
    let url: URL
    var showProgress: Bool = true
    var onURLChange: ((URL) -> Void)?
    var onLogout: (() -> Void)?
    var onPushServiceView: ((String) -> Void)?

    @StateObject private var viewModel = WebContainerViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            // WebView
            webViewContent

            // 进度条
            if showProgress && viewModel.isLoading && !viewModel.hasError {
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
            }
        }
        .onAppear {
            setupJSBridge()
        }
    }

    @ViewBuilder
    private var webViewContent: some View {
        if viewModel.hasError {
            ErrorRetryView(message: "页面加载失败，请检查网络后重试") {
                viewModel.retry()
            }
        } else {
            WebView(
                url: url,
                progress: $viewModel.progress,
                onURLChange: { url in
                    viewModel.isLoading = true
                    onURLChange?(url)
                },
                onFinish: {
                    viewModel.isLoading = false
                    viewModel.hasError = false
                },
                onFail: { error in
                    viewModel.isLoading = false
                    viewModel.hasError = true
                    print("[WebContainer] 加载失败: \(error.localizedDescription)")
                },
                jsBridgeHandler: viewModel.jsBridgeHandler
            )
        }
    }

    private func setupJSBridge() {
        viewModel.jsBridgeHandler.delegate = viewModel
        viewModel.onLogout = onLogout
        viewModel.onPushServiceView = onPushServiceView
    }
}

// MARK: - Web Container ViewModel

@MainActor
class WebContainerViewModel: ObservableObject, JSBridgeHandlerDelegate {
    @Published var progress: Double = 0
    @Published var isLoading: Bool = true
    @Published var hasError: Bool = false

    let jsBridgeHandler = JSBridgeHandler()

    var onLogout: (() -> Void)?
    var onPushServiceView: ((String) -> Void)?

    func retry() {
        hasError = false
        isLoading = true
    }

    // MARK: - JSBridgeHandlerDelegate

    func handleMessage(_ name: String, body: Any?) {
        // 通用消息处理
    }

    func handleLogout() {
        onLogout?()
    }

    func handleGetCacheSize(completion: @escaping (String) -> Void) {
        Task {
            let size = await calculateCacheSize()
            completion(size)
        }
    }

    func handleClearCache() {
        CookieManager.shared.clearCookies {
            print("[WebContainer] 缓存已清除")
        }
    }

    func handlePushServiceView(url: String) {
        onPushServiceView?(url)
    }

    func handleScanCode() {
        // TODO: 实现扫一扫
    }

    func handleCallPhone(phone: String) {
        guard let url = URL(string: "telprompt://\(phone)") else { return }
        #if !targetEnvironment(simulator)
        UIApplication.shared.open(url)
        #endif
    }

    func handleBackUp() {
        // 由 NavigationStack 处理
    }

    func handleExitPage() {
        // 由 NavigationStack 处理
    }

    func handleReturnFromIscToAppFunc(body: String?) {
        // ISC 返回处理
    }

    // MARK: - Private Methods

    private func calculateCacheSize() async -> String {
        await withCheckedContinuation { continuation in
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                let totalSize = records.reduce(0.0) { sum, _ in sum + 0.1 }
                continuation.resume(returning: String(format: "%.1f MB", totalSize))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    WebContainerView(url: URL(string: "https://app.hfit.edu.cn")!)
}
