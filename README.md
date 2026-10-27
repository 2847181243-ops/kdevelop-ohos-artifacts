# kdevelop-ohos-artifacts

KDevelop for HarmonyOS PC 的 **HAP 构建产物**存放处。源码在 AtomGit：
<https://atomgit.com/jumping_ggjjkk/kdevelop-ohos>

> 这里只放二进制包和校验清单，不放源码。每个版本对应一个 GitHub Release，
> HAP 作为 release asset 上传（GitHub 单文件上限 2 GB，260 MB 的包没问题）。

## 怎么下载

```bash
# 方式一：直接下最新版
gh release download --repo 2847181243-ops/kdevelop-ohos-artifacts --pattern '*.hap'

# 方式二：用本仓库脚本（会校验 sha256）
./fetch.sh v0.9.28          # Linux/macOS
powershell -File fetch.ps1 -Tag v0.9.28
```

## 版本一览

| Tag | 文件 | 大小 | 说明 |
|---|---|---|---|
| v0.9.28 | `kdevelop-0.9.28-slim-signed.hap` | 264.1 MB | 去掉 `.so.X.Y.Z` 副本，比上版小 61 MB |
| v0.9.23 | `kdevelop-0.9.23-*` | 320 MB | G2 闭环首个可用版（新建/输入/保存走通） |

## 校验

每个 Release 里都有 `SHA256SUMS`；下载后：

```bash
sha256sum -c SHA256SUMS
```

Windows：

```powershell
Get-FileHash .\*.hap -Algorithm SHA256
```

## 签名说明

- Release 里的包多数是 **OpenHarmony 社区 CA 自签名**，只能装在允许社区证书的设备上；
- 华为设备需要用自己的调试证书重签：`hap-sign-tool.jar` + 各自的 profile；
- 包内组件：Qt 6.13（SDK 自带 qohos 平台插件）+ KDE Frameworks 6.7 + KDevelop 6.7
  + 53 个 KDevelop 插件 + 自建的 clang/libclang 交叉编译产物。

## 许可

包内是 GPL/LGPL 组件的二进制。对应源码：

- KDevelop / KDevPlatform / KF6 / Qt：见 <https://atomgit.com/jumping_ggjjkk/kdevelop-ohos> 及其 `vendor/` 子树；
- 构建脚本与补丁：同一仓库的 `scripts/` 与 `patches/`。
