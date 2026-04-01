//
//  PrivacyPopupView.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import SwiftUI

struct PrivacyPopupView: View {
    @AppStorage("privacyAccepted") private var privacyAccepted = false
    @Binding var isPresented: Bool
    @State private var showPrivacyDetail = false

    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            // 弹窗内容
            VStack(spacing: 0) {
                // 标题
                Text("用户隐私协议")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 24)
                    .padding(.bottom, 16)

                // 协议内容
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("欢迎使用合肥理工学院校园APP！")
                            .font(.system(size: 15, weight: .medium))

                        Text("在使用本应用前，请您仔细阅读并同意以下协议：")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        privacyContentText

                        Button(action: {
                            showPrivacyDetail = true
                        }) {
                            Text("《用户隐私协议》")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .frame(maxHeight: 300)

                Divider()

                // 按钮区域
                HStack(spacing: 0) {
                    Button(action: {
                        handleDisagree()
                    }) {
                        Text("不同意")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }

                    Divider()
                        .frame(height: 50)

                    Button(action: {
                        handleAgree()
                    }) {
                        Text("同意")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
            }
            .frame(maxWidth: 320)
            .padding(.horizontal, 30)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
        }
        .sheet(isPresented: $showPrivacyDetail) {
            PrivacyDetailView()
        }
    }

    // MARK: - Privacy Content

    private var privacyContentText: some View {
        VStack(alignment: .leading, spacing: 8) {
            privacyItem("1. 我们会收集您的账号信息用于登录认证")
            privacyItem("2. 我们会收集必要的设备信息以提供更好的服务")
            privacyItem("3. 我们承诺保护您的个人隐私和数据安全")
            privacyItem("4. 您可以随时查看和管理您的个人信息")
        }
    }

    private func privacyItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Actions

    private func handleAgree() {
        privacyAccepted = true
        isPresented = false
    }

    private func handleDisagree() {
        // 不同意则退出应用
        exit(0)
    }
}

// MARK: - Privacy Detail View

struct PrivacyDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("用户隐私协议")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)

                    privacySection(
                        title: "一、信息收集",
                        content: "为了向您提供更好的服务，我们会收集以下信息：\n• 账号信息（学号、姓名等）\n• 设备信息（设备型号、系统版本等）\n• 使用信息（访问记录、操作日志等）"
                    )

                    privacySection(
                        title: "二、信息使用",
                        content: "我们收集的信息将用于：\n• 提供校园服务功能\n• 改进用户体验\n• 保障账号安全\n• 统计分析和优化"
                    )

                    privacySection(
                        title: "三、信息保护",
                        content: "我们承诺：\n• 采用行业标准的安全措施保护您的信息\n• 不会向第三方出售或泄露您的个人信息\n• 严格限制信息访问权限\n• 定期进行安全审计"
                    )

                    privacySection(
                        title: "四、用户权利",
                        content: "您有权：\n• 查看和更新您的个人信息\n• 删除您的账号和数据\n• 拒绝特定信息的收集\n• 随时联系我们咨询隐私问题"
                    )
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    PrivacyPopupView(isPresented: .constant(true))
}
