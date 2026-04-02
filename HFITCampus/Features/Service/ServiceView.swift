//
//  ServiceView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

struct ServiceView: View {
    let onLogout: () -> Void
    var onPushServiceView: ((String) -> Void)? = nil

    var body: some View {
        H5TabPageView(
            title: "服务",
            path: "service",
            onLogout: onLogout,
            onPushServiceView: onPushServiceView
        )
    }
}

#Preview {
    NavigationStack {
        ServiceView(onLogout: {})
    }
}
