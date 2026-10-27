## kdevelop-0.9.28（slIM）

- 去掉 `.so.X.Y.Z` 完整版本副本（62 个 / 95.7 MB，没有任何库 NEEDED 它们）
- 未签名 260.1 MB → 签名 264.1 MB（上一版 325 MB）
- qohos：SDK 自带即可用版（包内 strip 后 5 354 440 B）
- 权限：仅 INTERNET（受限目录权限在无 ACL 的 profile 下会被系统静默丢弃）
- 主库：HOME/XDG 指向应用沙箱；KOHLOG 日志留痕；itemrepository store() 由 qFatal 降级

安装：华为设备需用自己的调试证书重签（hap-sign-tool.jar + 自己的 profile）。