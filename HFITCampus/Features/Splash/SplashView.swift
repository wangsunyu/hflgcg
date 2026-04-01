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

            // 广告图
            if viewModel.showAd, let imageURL = viewModel.adImageURL {
                adImageView(url: imageURL)
            }

            // 跳过按钮（广告页显示）
            if viewModel.showAd {
                skipButton
            }
        }
        .ignoresSafeArea()
        .onChange(of: viewModel.countdown) { _, newValue in
            if newValue == 0 {
                navigateToLogin()
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private func adImageView(url: String) -> some View {
        VStack {
            Spacer()

            AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 300)
            .clipped()
            .onTapGesture {
                handleAdTap()
            }

            Spacer()
        }
    }

    private var skipButton: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    viewModel.skip()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 50, height: 50)

                        Text("\(viewModel.countdown)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Actions

    private func navigateToLogin() {
        appState.currentRoute = .login
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

                // 根据屏幕尺寸选择启动图
                Image(launchImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
    }

    private var launchImageName: String {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        switch screenHeight {
        case 812:  // iPhone X/XS/11 Pro
            return "X"
        case 896:  // iPhone XS Max/11 Pro Max
            return "MAX"
        case 667:  // iPhone 8/SE
            return "6"
        case 568:  // iPhone 5/5S/SE (1st)
            return "5"
        case 844:  // iPhone 13/14
            return "14"
        case 852:  // iPhone 14 Pro
            return "14P"
        case 932:  // iPhone 14 Pro Max
            return "14PM"
        default:
            if screenWidth == 375 {
                return "6"
            } else if screenWidth == 320 {
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
