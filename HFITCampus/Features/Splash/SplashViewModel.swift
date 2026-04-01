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
    @Published var ad跳转链接: String?
    @Published var countdown: Int = 3
    @Published var isLoading: Bool = true
    @Published var loadFailed: Bool = false
    @Published var showAd: Bool = false

    // MARK: - Private Properties

    private var countdownTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UserDefaults Keys

    private enum Keys {
        static let cachedImageURL = "cachedAdImageURL"
        static let cachedImageData = "cachedAdImageData"
        static let cached跳转链接 = "cachedAd跳转链接"
    }

    // MARK: - Initialization

    init() {
        loadAdvertisement()
    }

    deinit {
        countdownTimer?.invalidate()
    }

    // MARK: - Public Methods

    func loadAdvertisement() {
        isLoading = true
        loadFailed = false

        Task {
            do {
                let ad: Advertisement = try await NetworkService.shared.get(url: APIConfig.advertisement)
                await MainActor.run {
                    self.handleAdResponse(ad)
                }
            } catch {
                await MainActor.run {
                    self.loadCachedOrSkip()
                }
            }
        }
    }

    func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
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
            ad跳转链接 = ad.data?.tzlj
            showAd = true
            startCountdown()

            // 缓存图片 URL 和数据
            cacheAdData(imageURL: imageURL, jumpURL: ad.data?.tzlj)
        } else {
            // 无广告，直接跳过
            showAd = false
            countdown = 0
        }
    }

    private func loadCachedOrSkip() {
        isLoading = false

        // 尝试加载缓存图片
        if let cachedURL = UserDefaults.standard.string(forKey: Keys.cachedImageURL),
           let _ = UserDefaults.standard.data(forKey: Keys.cachedImageData) {
            adImageURL = cachedURL
            ad跳转链接 = UserDefaults.standard.string(forKey: Keys.cached跳转链接)
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
        UserDefaults.standard.set(jumpURL, forKey: Keys.cached跳转链接)
    }
}
