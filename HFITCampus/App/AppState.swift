//
//  AppState.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import Foundation
import Combine

class AppState: ObservableObject {

    // MARK: - Route Enum

    enum Route {
        case splash       // 广告页
        case login        // 登录页
        case main         // 主TabBar
    }

    // MARK: - Published Properties

    @Published var currentRoute: Route = .splash
    @Published var appId: String = ""
}
