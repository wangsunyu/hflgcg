//
//  SplashViewModel.swift
//  HFITCampus
//
//  Created on 2026-04-01.
//

import Foundation
import Combine

// MARK: - Advertisement Model

struct Advertisement: Codable {
    let flag: Bool
    let data: AdData?
}

struct AdData: Codable {
    let url: String
    let tzlj: String?  // 跳转链接
}

// MARK: - Splash ViewModel

@MainActor
class SplashViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var adImageURL: String?
    @Published var adJumpURL: String?
    @Published var countdown: Int = 3
    @Published var showAd: Bool = false
    @Published var isLoading: Bool = true  // 添加加载状态

    // MARK: - Private Properties

    private var countdownTimer: Timer?

    // MARK: - UserDefaults Keys

    private enum Keys {
        static let cachedImageURL = "cachedAdImageURL"
        static let cachedJumpURL = "cachedAdJumpURL"
    }

    // MARK: - Initialization

    init() {
        print("[SplashViewModel] init - 开始加载广告")
        print("[SplashViewModel] 当前 showAd = \(showAd), countdown = \(countdown)")
        loadAdvertisement()
    }

    deinit {
        print("[SplashViewModel] deinit")
        countdownTimer?.invalidate()
    }

    // MARK: - Public Methods

    func loadAdvertisement() {
        Task {
            do {
                let params = ["_userType": UserManager.shared.userType]
                let ad: Advertisement = try await NetworkService.shared.postForm(
                    url: APIConfig.advertisement,
                    params: params
                )
                handleAdResponse(ad)
            } catch {
                print("[SplashViewModel] 广告加载失败: \(error.localizedDescription)")
                loadCachedOrSkip()
            }
        }
    }

    func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.tick() }
        }
    }

    func skip() {
        countdownTimer?.invalidate()
        countdown = 0
    }

    // MARK: - Private Methods

    private func handleAdResponse(_ ad: Advertisement) {
        isLoading = false
        if ad.flag, let imageURL = ad.data?.url, !imageURL.isEmpty {
            adImageURL = imageURL
            adJumpURL = ad.data?.tzlj
            showAd = true
            startCountdown()
            cacheAdData(imageURL: imageURL, jumpURL: ad.data?.tzlj)
        } else {
            // 无广告，直接跳过
            showAd = false
            countdown = 0
        }
    }

    private func loadCachedOrSkip() {
        isLoading = false
        // 尝试加载缓存的广告 URL
        if let cachedURL = UserDefaults.standard.string(forKey: Keys.cachedImageURL) {
            adImageURL = cachedURL
            adJumpURL = UserDefaults.standard.string(forKey: Keys.cachedJumpURL)
            showAd = true
            startCountdown()
        } else {
            // 无缓存，直接跳过
            showAd = false
            countdown = 0
        }
    }

    private func tick() {
        if countdown > 0 {
            countdown -= 1
        } else {
            countdownTimer?.invalidate()
        }
    }

    private func cacheAdData(imageURL: String, jumpURL: String?) {
        UserDefaults.standard.set(imageURL, forKey: Keys.cachedImageURL)
        UserDefaults.standard.set(jumpURL, forKey: Keys.cachedJumpURL)
    }
}
