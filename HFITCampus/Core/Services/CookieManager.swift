//
//  CookieManager.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import Foundation
import WebKit

class CookieManager {
    static let shared = CookieManager()

    private enum Keys {
        static let savedCookies = "savedCookies"
    }

    private init() {}

    // MARK: - Save Cookies

    func saveCookies(from webView: WKWebView, completion: (() -> Void)? = nil) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            let cookieData = try? NSKeyedArchiver.archivedData(withRootObject: cookies, requiringSecureCoding: false)
            UserDefaults.standard.set(cookieData, forKey: Keys.savedCookies)
            completion?()
        }
    }

    // MARK: - Restore Cookies

    func restoreCookies(to webView: WKWebView, completion: (() -> Void)? = nil) {
        guard let cookieData = UserDefaults.standard.data(forKey: Keys.savedCookies),
              let cookies = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, HTTPCookie.self], from: cookieData) as? [HTTPCookie] else {
            completion?()
            return
        }

        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        let group = DispatchGroup()

        for cookie in cookies {
            group.enter()
            cookieStore.setCookie(cookie) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion?()
        }
    }

    // MARK: - Clear Cookies

    func clearCookies(completion: (() -> Void)? = nil) {
        let dataStore = WKWebsiteDataStore.default()
        let dataTypes = Set([WKWebsiteDataTypeCookies])

        dataStore.removeData(ofTypes: dataTypes, modifiedSince: .distantPast) {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: Keys.savedCookies)
                completion?()
            }
        }
    }
}

