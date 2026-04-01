# 阶段 3: WebView 通用组件 - 原逻辑梳理

## 参考代码
- `SCPlatform/SCPlatform/Base/Controller/HtmlBaseVC.m`
- `SCPlatform/SCPlatform/Base/Controller/HtmlBaseVC.h`

## JS Bridge 消息列表

| 消息名 | 功能 | 参数 |
|--------|------|------|
| `docPreView` | 打开文档预览 | fileUrl, fileName |
| `backUp` | 返回上一页或退出 | - |
| `exitPage` | 关闭页面 | - |
| `photoModify` | 修改头像 | fileAddress |
| `callPhone` | 拨打电话 | phoneNumber |
| `returnFromIscToAppFunc` | ISC 返回 | ReturnDefault |
| `logout` | 退出登录 | - |
| `getCacheSize` | 获取缓存大小 | 回调 getCacheSizeCallback(size) |
| `clearCache` | 清除缓存 | - |
| `pushServiceView` | 跳转服务页 | url |
| `toServiceGuide` | 跳转服务指南 | id |
| `getBaiduMapLocation` | 获取百度地图定位 | - |
| `serviceUrlJumpNew` | 服务项点击 | 自定义参数 |
| `postList` | 跳转实习H5 | path |
| `scanCode` | 扫一扫 | - |

## 核心设计

### 1. WeakScriptMessageHandler 避免循环引用

```objc
@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end

@implementation WeakScriptMessageDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
```

### 2. WebView 配置

```objc
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
WKUserContentController *userContent = [[WKUserContentController alloc] init];
configuration.userContentController = userContent;

// 注册 JS Bridge 消息处理
[userContent addScriptMessageHandler:self name:@"backUp"];
[userContent addScriptMessageHandler:self name:@"logout"];
// ... 其他消息
```

### 3. 进度条监听 (KVO)

```objc
[detailsWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        progressView.progress = detailsWebView.estimatedProgress;
    }
}
```

### 4. 加载失败处理

```objc
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    nilView.hidden = NO; // 显示加载失败视图
}
```

## API 接口

- 无额外 API，主要通过 JS Bridge 与 H5 交互

## 待开发文件

- `Features/WebContainer/WebView.swift` - WKWebView SwiftUI 封装
- `Features/WebContainer/JSBridgeHandler.swift` - JS 交互处理
- `Features/WebContainer/WebContainerView.swift` - H5 容器页
- `UI/Components/LoadingView.swift` - 加载指示器
- `UI/Components/ErrorRetryView.swift` - 加载失败重试视图

---

## ✅ 原逻辑验证结果 (2026-04-01)

### 1. JS Bridge 消息列表
| 消息名 | 功能 | 实现状态 |
|--------|------|----------|
| `docPreView` | 打开文档预览 | ⚠️ TODO |
| `backUp` | 返回上一页或退出 | ✅ 已实现 |
| `exitPage` | 关闭页面 | ✅ 已实现 |
| `photoModify` | 修改头像 | ⚠️ TODO |
| `callPhone` | 拨打电话 | ✅ 已实现 |
| `returnFromIscToAppFunc` | ISC 返回 | ✅ 已实现 |
| `logout` | 退出登录 | ✅ 已实现 |
| `getCacheSize` | 获取缓存大小 | ✅ 已实现 |
| `clearCache` | 清除缓存 | ✅ 已实现 |
| `pushServiceView` | 跳转服务页 | ✅ 已实现 |
| `toServiceGuide` | 跳转服务指南 | ⚠️ TODO |
| `getBaiduMapLocation` | 获取百度地图定位 | ⚠️ TODO |
| `serviceUrlJumpNew` | 服务项点击 | ⚠️ TODO |
| `postList` | 跳转实习H5 | ⚠️ TODO |
| `scanCode` | 扫一扫 | ⚠️ TODO |

### 2. 核心设计验证
- [x] **WeakScriptMessageHandler** - 已实现 `WeakScriptMessageHandler` 类
- [x] **WebView 配置** - 已配置 WKWebViewConfiguration + WKUserContentController
- [x] **进度条监听** - 已实现 KVO estimatedProgress
- [x] **加载失败处理** - 已实现 ErrorRetryView 显示

### 3. 功能验证
- [x] WebContainerView 能加载任意 URL 并显示进度条
- [x] JS Bridge 消息能正确接收和分发
- [x] 加载失败显示重试视图
- [x] 各屏幕尺寸自适应

### 待完善
- 部分 JS Bridge 消息（扫一扫、地图定位等）需要后续根据实际业务实现
