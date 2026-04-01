//
//  UserManager.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import Foundation
import Combine

// MARK: - Login Info Model

struct LoginInfo {
    let token: String
    let userCode: String
    let userName: String
    var userType: String = ""
    var refreshToken: String = ""
    var fileAddress: String = ""
}

// MARK: - User Manager

class UserManager: ObservableObject {
    static let shared = UserManager()

    // MARK: - UserDefaults Keys

    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let token = "token"
        static let userCode = "userCode"
        static let userName = "userName"
        static let userType = "userType"
        static let refreshToken = "refreshToken"
        static let fileAddress = "fileAddress"
    }

    // MARK: - Published Properties

    @Published var isLoggedIn: Bool {
        didSet { UserDefaults.standard.set(isLoggedIn, forKey: Keys.isLoggedIn) }
    }
    @Published var token: String {
        didSet { UserDefaults.standard.set(token, forKey: Keys.token) }
    }
    @Published var userCode: String {
        didSet { UserDefaults.standard.set(userCode, forKey: Keys.userCode) }
    }
    @Published var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: Keys.userName) }
    }
    @Published var userType: String {
        didSet { UserDefaults.standard.set(userType, forKey: Keys.userType) }
    }
    @Published var refreshToken: String {
        didSet { UserDefaults.standard.set(refreshToken, forKey: Keys.refreshToken) }
    }
    @Published var fileAddress: String {
        didSet { UserDefaults.standard.set(fileAddress, forKey: Keys.fileAddress) }
    }

    private init() {
        isLoggedIn = UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        token = UserDefaults.standard.string(forKey: Keys.token) ?? ""
        userCode = UserDefaults.standard.string(forKey: Keys.userCode) ?? ""
        userName = UserDefaults.standard.string(forKey: Keys.userName) ?? ""
        userType = UserDefaults.standard.string(forKey: Keys.userType) ?? ""
        refreshToken = UserDefaults.standard.string(forKey: Keys.refreshToken) ?? ""
        fileAddress = UserDefaults.standard.string(forKey: Keys.fileAddress) ?? ""
    }

    // MARK: - Public Methods

    func saveLoginInfo(_ info: LoginInfo) {
        token = info.token
        userCode = info.userCode
        userName = info.userName
        userType = info.userType
        refreshToken = info.refreshToken
        fileAddress = info.fileAddress
        isLoggedIn = true
    }

    func clearUserInfo() {
        token = ""
        userCode = ""
        userName = ""
        userType = ""
        refreshToken = ""
        fileAddress = ""
        isLoggedIn = false
    }

    func encodedToken() -> String {
        return token.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? token
    }
}
