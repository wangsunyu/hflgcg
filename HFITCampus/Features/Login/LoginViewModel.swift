//
//  LoginViewModel.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import Foundation
import Combine
import WebKit

@MainActor
class LoginViewModel: ObservableObject {
    @Published var progress: Double = 0
    @Published var isPreparing: Bool = false
    @Published var isLoggingIn: Bool = false
    @Published var errorMessage: String?
    @Published var webLoadFailed: Bool = false
    @Published var appId: String = ""
    @Published var loginURL: URL? = nil

    private let appState: AppState
    private weak var webView: WKWebView?
    private var hasStartedLoginExchange = false
    private var capturedMobileCode: String?

    private static let mobileCodeKey = "mobile_code"

    var hasError: Bool {
        errorMessage != nil
    }

    init(appState: AppState) {
        self.appState = appState
    }

    func loadAppIdIfNeeded() {
        guard !isPreparing, loginURL == nil else { return }

        Task {
            await prepareLogin()
        }
    }

    func retry() {
        resetLoginState(clearURL: true)
        loadAppIdIfNeeded()
    }

    func bindWebView(_ webView: WKWebView) {
        self.webView = webView
    }

    func handleURLChange(_ url: URL) {
        guard !hasStartedLoginExchange else { return }
        guard let mobileCode = extractMobileCode(from: url), !mobileCode.isEmpty else {
            return
        }

        guard capturedMobileCode != mobileCode else { return }

        capturedMobileCode = mobileCode
        hasStartedLoginExchange = true

        Task {
            await completeLogin(with: mobileCode)
        }
    }

    func handleWebFinish() {
        webLoadFailed = false
        if errorMessage == LoginErrorMessages.webLoadFailed {
            errorMessage = nil
        }
    }

    func handleWebFail(_ error: Error) {
        if isLoggingIn { return }
        webLoadFailed = true
        errorMessage = error.localizedDescription.isEmpty ? LoginErrorMessages.webLoadFailed : error.localizedDescription
    }

    private func prepareLogin() async {
        isPreparing = true
        webLoadFailed = false
        errorMessage = nil

        defer {
            isPreparing = false
        }

        do {
            let response: AppIdResponse = try await NetworkService.shared.get(url: APIConfig.getAppId)
            guard response.code == 200, let fetchedAppId = response.data, !fetchedAppId.isEmpty else {
                throw LoginError.invalidResponse(response.message ?? LoginErrorMessages.fetchAppIdFailed)
            }

            guard let loginURL = URLBuilder.buildCASAuthURL(appId: fetchedAppId) else {
                throw LoginError.invalidLoginURL
            }

            appId = fetchedAppId
            appState.appId = fetchedAppId
            self.loginURL = loginURL
        } catch {
            webLoadFailed = true
            errorMessage = error.localizedDescription
        }
    }

    private func completeLogin(with code: String) async {
        isLoggingIn = true
        errorMessage = nil

        do {
            let tokenResponse: TokenResponse = try await NetworkService.shared.postForm(
                url: APIConfig.getTokenByCode,
                params: [LoginViewModel.mobileCodeKey: code]
            )

            guard tokenResponse.code == 200,
                  let token = tokenResponse.data,
                  !token.isEmpty else {
                throw LoginError.invalidResponse(tokenResponse.message ?? LoginErrorMessages.fetchTokenFailed)
            }

            let profileResponse: UserProfileResponse = try await NetworkService.shared.postForm(
                url: APIConfig.userProfile,
                params: ["token": token]
            )

            guard profileResponse.code == 200,
                  let profile = profileResponse.data else {
                throw LoginError.invalidResponse(profileResponse.message ?? LoginErrorMessages.fetchProfileFailed)
            }

            let loginInfo = LoginInfo(
                token: token,
                userCode: profile.userCode,
                userName: profile.userName,
                userType: profile.userType,
                refreshToken: profile.refreshToken,
                fileAddress: profile.fileAddress
            )

            UserManager.shared.saveLoginInfo(loginInfo)

            if let webView {
                Task {
                    await saveCookies(from: webView)
                }
            }

            appState.currentRoute = .main
        } catch {
            UserManager.shared.clearUserInfo()
            isLoggingIn = false
            hasStartedLoginExchange = false
            errorMessage = error.localizedDescription
        }
    }

    private func saveCookies(from webView: WKWebView) async {
        await withCheckedContinuation { continuation in
            CookieManager.shared.saveCookies(from: webView) {
                continuation.resume()
            }
        }
    }

    private func extractMobileCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        if let mobileCode = components.queryItems?.first(where: { $0.name == LoginViewModel.mobileCodeKey })?.value,
           !mobileCode.isEmpty {
            return mobileCode
        }

        if let absoluteString = url.absoluteString.removingPercentEncoding,
           let range = absoluteString.range(of: "\(LoginViewModel.mobileCodeKey)=") {
            let codeString = absoluteString[range.upperBound...]
            return codeString.split(separator: "#", maxSplits: 1).first.map(String.init)
        }

        return nil
    }

    private func resetLoginState(clearURL: Bool) {
        progress = 0
        isPreparing = false
        isLoggingIn = false
        webLoadFailed = false
        errorMessage = nil
        hasStartedLoginExchange = false
        capturedMobileCode = nil
        if clearURL {
            loginURL = nil
            appId = ""
        }
    }
}

// MARK: - Constants

private enum LoginErrorMessages {
    static let webLoadFailed = "登录页面加载失败，请重试"
    static let fetchAppIdFailed = "获取 appId 失败"
    static let fetchTokenFailed = "获取 token 失败"
    static let fetchProfileFailed = "获取用户信息失败"
}

// MARK: - Errors

extension LoginViewModel {
    enum LoginError: LocalizedError {
        case invalidLoginURL
        case invalidResponse(String)

        var errorDescription: String? {
            switch self {
            case .invalidLoginURL:
                return "登录地址生成失败"
            case .invalidResponse(let message):
                return message
            }
        }
    }
}
