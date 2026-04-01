//
//  HFITCampusApp.swift
//  HFITCampus
//
//  Created by wsy on 2026/3/31.
//

import SwiftUI

@main
struct HFITCampusApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var userManager = UserManager.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(userManager)
                .environmentObject(networkMonitor)
        }
    }
}

// MARK: - Root View

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("privacyAccepted") private var privacyAccepted = false

    var body: some View {
        ZStack {
            switch appState.currentRoute {
            case .splash:
                SplashView()
            case .login:
                Text("登录页")
            case .main:
                Text("主页")
            }

            // 隐私弹窗（首次启动时显示）
            if !privacyAccepted {
                PrivacyPopupView(isPresented: .constant(true))
            }
        }
    }
}

