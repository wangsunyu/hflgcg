# 📋 将文件添加到 Xcode 项目的操作指南

## 需要添加的文件清单

### ✅ 已创建的 Swift 文件（共 8 个）

```
HFITCampus/
├── App/
│   └── AppState.swift                    ✅ 已创建
├── Core/
│   ├── Config/
│   │   └── APIConfig.swift               ✅ 已创建
│   ├── Models/
│   │   └── UserManager.swift             ✅ 已创建
│   ├── Network/
│   │   ├── NetworkMonitor.swift          ✅ 已创建
│   │   └── NetworkService.swift          ✅ 已创建
│   └── Services/
│       ├── CookieManager.swift           ✅ 已创建
│       └── URLBuilder.swift              ✅ 已创建
└── UI/
    └── Theme/
        └── AppTheme.swift                ✅ 已创建
```

---

## 📝 操作步骤

### 方法 1：在 Xcode 中手动添加（推荐）

1. **打开 Xcode 项目**
   ```bash
   open HFITCampus.xcodeproj
   ```

2. **在 Finder 中打开项目文件夹**
   - 在 Xcode 左侧项目导航器中，右键点击 `HFITCampus` 文件夹
   - 选择 "Show in Finder"

3. **拖拽文件到 Xcode**
   - 在 Finder 中选中以下文件夹：
     - `App` 文件夹
     - `Core` 文件夹
     - `UI` 文件夹
   - 拖拽到 Xcode 左侧项目导航器的 `HFITCampus` 组下
   - 在弹出的对话框中：
     - ✅ 勾选 "Copy items if needed"（如果需要）
     - ✅ 勾选 "Create groups"
     - ✅ 确保 Target 选中了 "HFITCampus"
   - 点击 "Finish"

4. **验证文件已添加**
   - 在 Xcode 项目导航器中应该能看到所有文件
   - 文件应该显示为黑色（不是红色）

5. **编译项目**
   - 按 `Cmd + B` 编译
   - 如果有错误，查看错误信息并修复

---

### 方法 2：使用命令行打开 Xcode（快捷方式）

```bash
cd "/Users/wsy/Desktop/code/iOS项目/合肥理工_副本4/HFITCampus"
open HFITCampus.xcodeproj
```

然后按照方法 1 的步骤 2-5 操作。

---

## ⚠️ 注意事项

1. **确保勾选 Target**：添加文件时必须勾选 "HFITCampus" target，否则文件不会被编译
2. **创建 Groups 而非 Folder References**：选择 "Create groups"（黄色文件夹图标），不要选择 "Create folder references"（蓝色文件夹图标）
3. **检查文件颜色**：添加成功后，文件名应该是黑色的，如果是红色说明文件路径有问题

---

## 🔍 验证步骤

添加完文件后，请执行以下验证：

1. **检查文件是否在项目中**
   - 在 Xcode 项目导航器中能看到所有 8 个文件
   - 文件名显示为黑色

2. **编译项目**
   ```
   Cmd + B
   ```
   - 应该编译成功，没有错误

3. **运行项目**
   ```
   Cmd + R
   ```
   - 应该能在模拟器中看到 "广告页" 文字（临时占位）

---

## 📞 如果遇到问题

如果添加文件后编译出错，请告诉我具体的错误信息，我会帮你解决。

常见问题：
- **文件显示为红色**：文件路径不正确，需要重新添加
- **编译错误 "No such module"**：可能是 import 语句有问题
- **编译错误 "Use of undeclared type"**：文件没有正确添加到 target

---

## ✅ 完成后

添加完文件并编译成功后，请告诉我，我们将继续：
- **任务 0.11**：验证阶段 0（测试网络请求等）
- 然后进入**阶段 1**：开发隐私协议弹窗
