//
//  JSBridgeHandler.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import Foundation
import WebKit

// MARK: - JS Bridge Message Types

enum JSBridgeMessage: String, CaseIterable {
    case backUp
    case exitPage
    case photoModify
    case callPhone
    case returnFromIscToAppFunc
    case logout
    case getCacheSize
    case clearCache
    case pushServiceView
    case scanCode
    case docPreView
    case getBaiduMapLocation
    case serviceUrlJumpNew
}

// MARK: - JSBridge Handler Protocol

protocol JSBridgeHandlerDelegate: AnyObject {
    func handleMessage(_ name: String, body: Any?)
    func handleLogout()
    func handleGetCacheSize(completion: @escaping (String) -> Void)
    func handleClearCache()
    func handlePushServiceView(url: String)
    func handleScanCode()
    func handleCallPhone(phone: String)
    func handleBackUp()
    func handleExitPage()
    func handleReturnFromIscToAppFunc(body: String?)
}

// MARK: - JSBridge Handler

class JSBridgeHandler: NSObject, WKScriptMessageHandler {
    // MARK: - Properties

    weak var delegate: JSBridgeHandlerDelegate?

    var supportedMessages: [String] {
        JSBridgeMessage.allCases.map { $0.rawValue }
    }

    // MARK: - WKScriptMessageHandler

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        let body = message.body

        guard let messageType = JSBridgeMessage(rawValue: name) else {
            print("[JSBridge] 未知消息: \(name)")
            return
        }

        switch messageType {
        case .backUp:
            delegate?.handleBackUp()

        case .exitPage:
            delegate?.handleExitPage()

        case .photoModify:
            break // TODO: 处理头像修改

        case .callPhone:
            if let phone = body as? String {
                delegate?.handleCallPhone(phone: phone)
            }

        case .returnFromIscToAppFunc:
            delegate?.handleReturnFromIscToAppFunc(body: body as? String)

        case .logout:
            delegate?.handleLogout()

        case .getCacheSize:
            delegate?.handleGetCacheSize { size in
                print("[JSBridge] 缓存大小: \(size)")
            }

        case .clearCache:
            delegate?.handleClearCache()

        case .pushServiceView:
            if let dict = body as? [String: Any], let url = dict["url"] as? String {
                delegate?.handlePushServiceView(url: url)
            }

        case .scanCode:
            delegate?.handleScanCode()

        case .docPreView, .getBaiduMapLocation, .serviceUrlJumpNew:
            break // TODO: 后续实现
        }
    }

    // MARK: - Helper Methods

    func evaluateJavaScript(_ script: String, in webView: WKWebView, completion: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(script) { result, error in
            completion?(result, error)
        }
    }
}

// MARK: - Weak Script Message Handler Wrapper

class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.scriptDelegate = delegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}
