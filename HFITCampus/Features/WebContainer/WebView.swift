//
//  WebView.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import SwiftUI
import WebKit

// MARK: - WebView SwiftUI Wrapper

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var progress: Double
    var onWebViewCreated: ((WKWebView) -> Void)?
    var onURLChange: ((URL) -> Void)?
    var onFinish: (() -> Void)?
    var onFail: ((Error) -> Void)?
    var jsBridgeHandler: JSBridgeHandler?

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()

        // 注册 JS Bridge 消息处理（使用 WeakScriptMessageHandler 避免循环引用）
        if let handler = jsBridgeHandler {
            for messageName in handler.supportedMessages {
                let weakHandler = WeakScriptMessageHandler(delegate: handler)
                userContentController.add(weakHandler, name: messageName)
            }
        }

        configuration.userContentController = userContentController
        configuration.preferences.javaScriptEnabled = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        // 进度监听
        webView.addObserver(
            context.coordinator,
            forKeyPath: "estimatedProgress",
            options: [.new],
            context: nil
        )

        // 首次加载
        context.coordinator.shouldLoad = true
        onWebViewCreated?(webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // 只在首次加载时执行，避免重复恢复 Cookie / 重复加载
        context.coordinator.loadIfNeeded(on: webView)
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.removeObserver(coordinator, forKeyPath: "estimatedProgress")

        if let handler = coordinator.parent.jsBridgeHandler {
            let userContentController = webView.configuration.userContentController
            for messageName in handler.supportedMessages {
                userContentController.removeScriptMessageHandler(forName: messageName)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView
        var shouldLoad = false
        private var hasRestoredCookies = false

        init(_ parent: WebView) {
            self.parent = parent
        }

        func loadIfNeeded(on webView: WKWebView) {
            guard shouldLoad else { return }

            shouldLoad = false

            guard !hasRestoredCookies else {
                webView.load(URLRequest(url: parent.url))
                return
            }

            hasRestoredCookies = true
            CookieManager.shared.restoreCookies(to: webView) {
                webView.load(URLRequest(url: self.parent.url))
            }
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress", let webView = object as? WKWebView {
                DispatchQueue.main.async {
                    self.parent.progress = webView.estimatedProgress
                }
            }
        }

        // MARK: - WKNavigationDelegate

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.targetFrame?.isMainFrame == true, let url = navigationAction.request.url {
                parent.onURLChange?(url)
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onFinish?()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.onFail?(error)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.onFail?(error)
        }

        // MARK: - WKUIDelegate

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            // 处理新窗口打开
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var progress: Double = 0
        var body: some View {
            WebView(url: URL(string: "https://app.hfit.edu.cn")!, progress: $progress)
        }
    }
    return PreviewWrapper()
}
