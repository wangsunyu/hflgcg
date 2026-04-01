//
//  URLBuilder.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import Foundation

class URLBuilder {

    // MARK: - Build H5 URL

    static func buildH5URL(_ path: String, withAuth: Bool = true, appId: String = "") -> URL? {
        let baseURL = APIConfig.h5Base + path

        guard var components = URLComponents(string: baseURL) else {
            return nil
        }

        if withAuth {
            var queryItems: [URLQueryItem] = []

            let userManager = UserManager.shared

            // access_token
            if !userManager.token.isEmpty {
                queryItems.append(URLQueryItem(name: "access_token", value: userManager.encodedToken()))
            }

            // _userCode
            if !userManager.userCode.isEmpty {
                queryItems.append(URLQueryItem(name: "_userCode", value: userManager.userCode))
            }

            // _userName
            if !userManager.userName.isEmpty {
                queryItems.append(URLQueryItem(name: "_userName", value: userManager.userName))
            }

            // appId
            if !appId.isEmpty {
                queryItems.append(URLQueryItem(name: "appId", value: appId))
            }

            // _userType
            if !userManager.userType.isEmpty {
                queryItems.append(URLQueryItem(name: "_userType", value: userManager.userType))
            }

            // returnFromIscToAppFunc (JS Bridge 回调函数名)
            queryItems.append(URLQueryItem(name: "returnFromIscToAppFunc", value: "returnFromIscToAppFunc"))

            components.queryItems = queryItems
        }

        return components.url
    }

    // MARK: - Build CAS Auth URL

    static func buildCASAuthURL(appId: String) -> URL? {
        guard var components = URLComponents(string: APIConfig.casAuth) else {
            return nil
        }

        components.queryItems = [
            URLQueryItem(name: "appId", value: appId)
        ]

        return components.url
    }
}

