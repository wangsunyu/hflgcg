//
//  MessageView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

struct MessageView: View {
    let onLogout: () -> Void
    var onPushServiceView: ((String) -> Void)? = nil

    var body: some View {
        H5TabPageView(
            title: "消息",
            path: "message",
            onLogout: onLogout,
            onPushServiceView: onPushServiceView
        )
    }
}

#Preview {
    NavigationStack {
        MessageView(onLogout: {})
    }
}
