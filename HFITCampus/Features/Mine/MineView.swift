//
//  MineView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

struct MineView: View {
    let onLogout: () -> Void
    var onPushServiceView: ((String) -> Void)? = nil

    var body: some View {
        H5TabPageView(
            title: "我的",
            path: "my",
            onLogout: onLogout,
            onPushServiceView: onPushServiceView
        )
    }
}

#Preview {
    NavigationStack {
        MineView(onLogout: {})
    }
}
