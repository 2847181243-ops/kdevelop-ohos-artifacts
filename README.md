# kdevelop-ohos-artifacts

KDevelop for HarmonyOS PC 的 **HAP 构建产物**存放处。源码在 AtomGit：
<https://atomgit.com/jumping_ggjjkk/kdevelop-ohos>

> 这里只放二进制包和校验清单，不放源码。每个版本对应一个 GitHub Release，
> HAP 作为 release asset 上传（GitHub 单文件上限 2 GB，260~330 MB 的包没问题，
> 仓库本身clone 仍然只有几 KB）。

## 下载

**方式一：GitHub CLI（推荐）**

```bash
gh release download --repo 2847181243-ops/kdevelop-ohos-artifacts --pattern '*.hap'
```

**方式二：浏览器 / curl**

```
https://github.com/2847181243-ops/kdevelop-ohos-artifacts/releases
```

**方式三：国内直连被墙时走 ghproxy 镜像**（实测可用）

```
https://ghproxy.net/https://github.com/2847181243-ops/kdevelop-ohos-artifacts/releases/download/v0.9.28/kdevelop-0.9.28-slim-signed.hap
```

本仓库的 `fetch.sh` / `fetch.ps1` 会调用 `gh` 下载并校验 sha256（网络受限时请先给 gh 配代理，
或者直接用上面的 ghproxy 链接手动下）。

## 版本一览

| Tag | 文件 | 大小 | 说明 |
|---|---|---|---|
| v0.9.28 | `kdevelop-0.9.28-slim-signed.hap` | 264.1 MB | 瘦身版：去掉 `.so.X.Y.Z` 副本，比上版小 61 MB |
| v0.9.23 | `kdevelop-0.9.23-sdkqohos-bpatch-signed.hap` | 325 MB | G2 闭环首个可用版（新建/输入/保存走通） |

## 校验

每个 Release 都带 `SHA256SUMS`：

```bash
sha256sum -c SHA256SUMS
```

Windows：

```powershell
Get-FileHash .\*.hap -Algorithm SHA256
```

## 签名说明

- Release 里的包是 **OpenHarmony 社区 CA 自签名**，只能装在允许社区证书的设备上；
- 华为设备需用自己的调试证书重签（`hap-sign-tool.jar` + 自己的 profile）：
  这是签名 Profile 的 ACL 决定的，换签名就能装。

## 包内组成

- Qt 6.13（SDK 自带 `libqohos.so` 平台插件）
- KDE Frameworks 6.7（49 个库）+ KDevelop 6.7 / KDevPlatform 6.7
- 53 个 KDevelop 插件，放在 `libs/arm64-v8a/kdevplatform/67/`
- 自建交叉编译的 clang/libclang 18.1.8
- share 数据（图标/翻译，7 908 个文件）打成 `.so` 容器，运行时释放到应用沙箱

## 许可

包内是 GPL/LGPL 组件的二进制。对应源码：

- KDevelop / KDevPlatform / KF6 / Qt：见 <https://atomgit.com/jumping_ggjjkk/kdevelop-ohos> 及其 `vendor/` 子树；
- 构建脚本、补丁、核对报告：同一仓库的 `scripts/`、`patches/`、`reports/`。
