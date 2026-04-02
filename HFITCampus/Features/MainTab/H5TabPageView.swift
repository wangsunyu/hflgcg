//
//  H5TabPageView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

struct H5TabPageView: View {
    let title: String
    let pageURL: URL?
    let onLogout: () -> Void
    var onPushServiceView: ((String) -> Void)? = nil

    init(title: String, path: String, onLogout: @escaping () -> Void, onPushServiceView: ((String) -> Void)? = nil) {
        self.title = title
        self.pageURL = URLBuilder.buildH5URL(path, withAuth: true)
        self.onLogout = onLogout
        self.onPushServiceView = onPushServiceView
    }

    var body: some View {
        Group {
            if let pageURL {
                WebContainerView(
                    url: pageURL,
                    onLogout: onLogout,
                    onPushServiceView: onPushServiceView
                )
            } else {
                ErrorRetryView(message: "\(title)页面地址生成失败，请重新进入") {
                }
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        H5TabPageView(title: "服务", path: "service", onLogout: {})
    }
}
