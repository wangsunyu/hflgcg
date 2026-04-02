//
//  HomeView.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import SwiftUI

struct HomeView: View {
    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
                bannerPlaceholder
                serviceGridPlaceholder
                todoPlaceholder
            }
            .padding(AppTheme.paddingMedium)
        }
        .background(AppTheme.backgroundColor.ignoresSafeArea())
        .navigationTitle("首页")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var bannerPlaceholder: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Banner 区域")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimaryColor)

            Text("阶段 7 将在这里接入首页轮播图与活动展示。")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondaryColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 152, alignment: .topLeading)
        .padding(AppTheme.paddingLarge)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.primaryColor.opacity(0.18),
                            AppTheme.primaryColor.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                .stroke(AppTheme.primaryColor.opacity(0.12), lineWidth: 1)
        )
    }

    private var serviceGridPlaceholder: some View {
        sectionContainer(title: "服务网格", subtitle: "后续接入首页高频服务快捷入口。") {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(0..<8, id: \.self) { _ in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.backgroundColor)
                            .frame(width: 42, height: 42)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.backgroundColor)
                            .frame(height: 10)
                            .padding(.horizontal, 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
    }

    private var todoPlaceholder: some View {
        sectionContainer(title: "待办事项", subtitle: "后续接入个人业务提醒和状态概览。") {
            VStack(spacing: 12) {
                todoRow(widthRatio: 0.52)
                todoRow(widthRatio: 0.7)
                todoRow(widthRatio: 0.44)
            }
        }
    }

    private func sectionContainer<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimaryColor)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondaryColor)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .stroke(AppTheme.separatorColor.opacity(0.35), lineWidth: 1)
        )
    }

    private func todoRow(widthRatio: CGFloat) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(AppTheme.backgroundColor)
                .frame(width: 10, height: 10)

            RoundedRectangle(cornerRadius: 5)
                .fill(AppTheme.backgroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 12)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(AppTheme.primaryColor.opacity(0.15))
                            .frame(width: proxy.size.width * widthRatio, height: 12)
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
