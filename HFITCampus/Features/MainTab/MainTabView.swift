//
//  MainTabView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var userManager: UserManager

    @State private var selectedTab: TabItem = .home
    @State private var loadedTabs: Set<TabItem> = [.home]

    init() {
        configureTabBarAppearance()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabItem.allCases, id: \.self) { item in
                NavigationStack {
                    tabContent(for: item)
                }
                .tag(item)
                .tabItem {
                    tabLabel(for: item)
                }
            }
        }
        .tint(AppTheme.primaryColor)
        .toolbar(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .onChange(of: selectedTab) { _, newValue in
            loadedTabs.insert(newValue)
        }
    }

    @ViewBuilder
    private func tabContent(for item: TabItem) -> some View {
        if loadedTabs.contains(item) || selectedTab == item {
            switch item {
            case .home:
                HomeView()
            case .service:
                ServiceView(onLogout: handleLogout, onPushServiceView: handlePushServiceView)
            case .message:
                MessageView(onLogout: handleLogout, onPushServiceView: handlePushServiceView)
            case .mine:
                MineView(onLogout: handleLogout, onPushServiceView: handlePushServiceView)
            }
        } else {
            LoadingView(message: "页面准备中...")
                .navigationTitle(item.title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private func tabLabel(for item: TabItem) -> some View {
        Image(selectedTab == item ? item.selectedIconName : item.iconName)
            .renderingMode(.original)

        Text(item.title)
    }

    private func handleLogout() {
        userManager.clearUserInfo()
        appState.currentRoute = .login
    }

    private func handlePushServiceView(_ _: String) {
        selectedTab = .service
    }
}

extension MainTabView {
    enum TabItem: CaseIterable {
        case home
        case service
        case message
        case mine

        var title: String {
            switch self {
            case .home:
                return "首页"
            case .service:
                return "服务"
            case .message:
                return "消息"
            case .mine:
                return "我的"
            }
        }

        var iconName: String {
            switch self {
            case .home:
                return "shouye"
            case .service:
                return "fuwu"
            case .message:
                return "xiaoxi"
            case .mine:
                return "wode"
            }
        }

        var selectedIconName: String {
            switch self {
            case .home:
                return "shouye_s"
            case .service:
                return "fuwu_s"
            case .message:
                return "xiaoxi_s"
            case .mine:
                return "wode_s"
            }
        }
    }
}

private extension MainTabView {
    func configureTabBarAppearance() {
        #if canImport(UIKit)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.18)

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 11)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(AppTheme.primaryColor),
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]

        let stacked = appearance.stackedLayoutAppearance
        stacked.normal.titleTextAttributes = normalAttributes
        stacked.selected.titleTextAttributes = selectedAttributes

        let inline = appearance.inlineLayoutAppearance
        inline.normal.titleTextAttributes = normalAttributes
        inline.selected.titleTextAttributes = selectedAttributes

        let compactInline = appearance.compactInlineLayoutAppearance
        compactInline.normal.titleTextAttributes = normalAttributes
        compactInline.selected.titleTextAttributes = selectedAttributes

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = .secondaryLabel
        #endif
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(UserManager.shared)
}
