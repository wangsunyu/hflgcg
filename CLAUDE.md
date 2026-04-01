# HFITCampus - 合肥理工学院校园APP

## 项目背景

全新纯 Swift/SwiftUI 重构项目，不做 OC 混编。旧代码仅参考业务逻辑（URL、API、登录流程等），UI 布局全部用 SwiftUI 原生方式重新实现。

**项目路径**: `/Users/wsy/Desktop/code/iOS项目/合肥理工_副本4/HFITCampus`

---

## 关键参数（从旧项目提取）

| 参数 | 值 |
|------|-----|
| 服务器域名 | `https://app.hfit.edu.cn` |
| API 前缀 | `https://app.hfit.edu.cn/zhxy-information/mobile/` |
| H5 前缀 | `https://app.hfit.edu.cn/app-portal/#/` |
| CAS 认证 | `https://ids-hfit-edu-cn-s.hfit.edu.cn/authserver/mobile/auth` |

---

## 开发计划

**详细开发计划**: `HFITCampus/开发计划.md`

该文件包含：
- 8 个开发阶段的完整任务清单
- 每个任务的状态（待完成 / 已完成 ✅）
- 布局原则和代码规范
- 工期估算

---

## 项目结构

```
HFITCampus/
├── HFITCampus/                    # 主源代码
│   ├── App/                       # 应用入口
│   │   ├── AppState.swift         # 全局路由状态
│   │   └── HFITCampusApp.swift    # @main 入口
│   ├── Core/                      # 核心模块
│   │   ├── Config/APIConfig.swift # API 常量
│   │   ├── Models/UserManager.swift
│   │   ├── Network/               # 网络层
│   │   └── Services/             # 服务类
│   ├── Features/                  # 功能模块（开发中）
│   │   ├── Privacy/               # 隐私弹窗 ✅
│   │   ├── Splash/                # 广告页
│   │   ├── Login/                 # 登录页
│   │   ├── MainTab/               # TabBar
│   │   ├── Home/                  # 首页
│   │   ├── Service/               # 服务页
│   │   ├── Message/               # 消息页
│   │   ├── Mine/                  # 个人中心
│   │   └── WebContainer/          # WebView + JS Bridge
│   └── UI/                        # UI 组件
│       ├── Components/           # 通用组件
│       └── Theme/AppTheme.swift  # 主题配置
├── 开发计划.md                    # 开发任务清单
├── 代码优化记录.md                # 代码优化记录
└── HFITCampus.xcodeproj
```

---

## 当前开发状态

### ✅ 已完成
- **阶段 0**: 基础架构（8个核心文件 + 代码优化）
- **阶段 1.1**: 隐私协议弹窗

### ⏳ 待开发
- **阶段 1.2**: 验证隐私弹窗
- **阶段 2**: 广告页
- **阶段 3**: WebView 组件 + H5 容器
- **阶段 4**: 登录页
- **阶段 5**: TabBar 主框架
- **阶段 6**: 消息页 + 个人中心 + 服务页
- **阶段 7**: 首页
- **阶段 8**: 完善 + 清理

---

## 开发规范

### 布局原则
- ✅ 使用 SwiftUI 自适应布局（VStack/HStack/LazyVGrid/ScrollView）
- ✅ 使用 `.padding()` 语义化间距
- ✅ 使用 `AsyncImage` + `.resizable().aspectRatio()` 处理图片
- ✅ 使用 `.font(.title)` 等语义化字体
- ✅ 使用 `Color(.systemBackground)` 适配深色模式
- ❌ 禁止使用固定屏幕宽度计算（如 autoWidth(375)）
- ❌ 禁止手动计算 statusBarHeight

### 代码规范
- 所有 ObservableObject 类需要 `import Combine`
- 使用 `@Published` 配合 `didSet` 自动同步 UserDefaults
- 网络请求使用 `async/await`
- 禁止使用弃用的 API（如 NSKeyedUnarchiver.unarchiveTopLevelObjectWithData）

---

## 快速命令

```bash
# 编译项目
cd /Users/wsy/Desktop/code/iOS项目/合肥理工_副本4/HFITCampus
xcodebuild -scheme HFITCampus -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' build

# 查看开发计划
open /Users/wsy/Desktop/code/iOS项目/合肥理工_副本4/HFITCampus/开发计划.md
```

---

## 注意事项

1. 每次开发前都会先询问用户，确认后再继续
2. 每个阶段完成后会更新开发计划文件
3. 发现问题会使用 `/simplify` 进行代码审查
4. 项目最低支持 iOS 16.0