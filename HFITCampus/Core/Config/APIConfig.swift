//
//  APIConfig.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import Foundation

enum APIConfig {
    // MARK: - Base URLs
    static let baseDomain = "https://app.hfit.edu.cn"
    static let apiBase = "\(baseDomain)/zhxy-information/mobile"
    static let h5Base = "\(baseDomain)/app-portal/#/"
    static let scpsBase = "\(baseDomain)/zhxy-scps"
    static let casAuth = "https://ids-hfit-edu-cn-s.hfit.edu.cn/authserver/mobile/auth"

    // MARK: - API Endpoints
    static let getAppId = "\(apiBase)/getAppId"
    static let getTokenByCode = "\(apiBase)/getTokenByCode"
    static let userProfile = "\(apiBase)/userProfile"
    static let logout = "\(apiBase)/logoutIOS"

    // MARK: - SCPS Endpoints
    static let advertisement = "\(scpsBase)/guide/getAdvertisment.do"
    static let bannerList = "\(scpsBase)/homePage/getBannerList.do"
    static let checkVersion = "\(scpsBase)/appInfo/checkVersion.do"

    // MARK: - H5 Pages
    static let privacyPolicy = "\(scpsBase)/privacy-policy.html"
}
