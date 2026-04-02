//
//  SplashView.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = SplashViewModel()

    var body: some View {
        ZStack {
            // 启动图背景
            LaunchBackgroundView()

            // 广告图 + 跳过按钮（仅广告显示时）
            if viewModel.showAd, let imageURL = viewModel.adImageURL {
                adContentView(url: imageURL)
            } else if viewModel.isLoading {
                // 加载中显示启动图
                EmptyView()
            }
        }
        .ignoresSafeArea()
        .onChange(of: viewModel.countdown) { oldValue, newValue in
            print("[SplashView] countdown: \(oldValue) -> \(newValue), showAd: \(viewModel.showAd)")
            if newValue == 0 && !viewModel.isLoading {
                print("[SplashView] 倒计时结束，执行启动分流")
                navigateToNextRoute()
            }
        }
    }

    // MARK: - Subviews

    private func adContentView(url: String) -> some View {
        GeometryReader { geometry in
            let adHeight = min(max(geometry.size.height * 0.66, 360), 537.5)

            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    adImageView(url: url)
                        .frame(width: geometry.size.width, height: adHeight)
                        .clipped()

                    skipButton
                        .padding(.trailing, 13)
                        .padding(.bottom, 15)
                }

                Spacer(minLength: 0)
            }
        }
    }

    @ViewBuilder
    private func adImageView(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.white
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(1.2)
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                ZStack {
                    Color.white
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            @unknown default:
                Color.white
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            handleAdTap()
        }
    }

    private var skipButton: some View {
        Button(action: {
            viewModel.skip()
        }) {
            ZStack {
                Image("跳过")
                    .resizable()
                    .frame(width: 50, height: 22)

                Text("\(viewModel.countdown)s")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .offset(x: 10)
            }
        }
    }

    // MARK: - Actions

    private func navigateToNextRoute() {
        appState.currentRoute = UserManager.shared.isLoggedIn ? .main : .login
    }

    private func handleAdTap() {
        // TODO: 点击广告跳转 WebView
        // 如果有跳转链接则打开
    }
}

// MARK: - Launch Background View

struct LaunchBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景色
                Color.white.ignoresSafeArea()

                // 用 GeometryReader 提供的实际尺寸选择启动图
                Image(launchImageName(for: geometry.size))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                EmptyView()
            }
        }
    }

    private func launchImageName(for size: CGSize) -> String {
        switch size.height {
        case 812, 844, 852:  // iPhone X/13/14/14 Pro 系列比例
            return "X"
        case 896, 932:  // Max / Plus / Pro Max 系列比例
            return "X"
        case 667:  // iPhone 8/SE
            return "6"
        case 568:  // iPhone 5/5S/SE (1st)
            return "5"
        default:
            if size.width == 375 {
                return "6"
            } else if size.width == 320 {
                return "5"
            }
            return "P"  // Default iPad
        }
    }
}

// MARK: - Preview

#Preview {
    SplashView()
        .environmentObject(AppState())
}
