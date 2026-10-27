## kdevelop-0.9.23（G2 首个可用版）

- 首次把 **新建 → 输入 → 保存** 全链路跑通（保存内容逐字节验证）
- qohos 用 SDK 自带版（我们自己重编的三版都会在 `QApplicationPrivate::init` 崩，reports/36/37/40）
- 53 个 KDevelop 插件，`kdevplatform/67/` 版本化目录
- 已知问题：关闭后重开文件失败（鸿蒙文件权限模型，reports/42）；关掉 Session Crashed 对话框会 SIGABRT（reports/45）

安装：华为设备需用自己的调试证书重签。