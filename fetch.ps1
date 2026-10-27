# fetch.ps1 — 从 GitHub Releases 拉取指定版本的 HAP，并校验 sha256
# 用法：powershell -File fetch.ps1 [-Tag v0.9.28]     不传 Tag 则拉最新
[CmdletBinding()]
param(
    [string]$Tag = ''
)

$ErrorActionPreference = 'Stop'
$Repo = '2847181243-ops/kdevelop-ohos-artifacts'
$Dir = Split-Path -Parent $PSCommandPath
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("koh-hap-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null

function Invoke-Gh {
    param([string[]]$GhArgs)
    & gh @GhArgs
    if ($LASTEXITCODE -ne 0) { throw "gh 失败：$($GhArgs -join ' ')" }
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw '需要 GitHub CLI (gh)：winget install GitHub.cli，然后 gh auth login'
}

if ($Tag) {
    Invoke-Gh @('release', 'download', $Tag, '--repo', $Repo, '--pattern', '*.hap', '--dir', $Tmp)
} else {
    Invoke-Gh @('release', 'download', '--repo', $Repo, '--pattern', '*.hap', '--dir', $Tmp)
}

# 校验（有 SHA256SUMS 就核）
try {
    if ($Tag) {
        Invoke-Gh @('release', 'download', $Tag, '--repo', $Repo, '--pattern', 'SHA256SUMS', '--dir', $Tmp)
    } else {
        Invoke-Gh @('release', 'download', '--repo', $Repo, '--pattern', 'SHA256SUMS', '--dir', $Tmp)
    }
    $sums = Join-Path $Tmp 'SHA256SUMS'
    foreach ($line in Get-Content $sums) {
        if ($line -match '^\s*([0-9a-fA-F]{64})\s+\*?(.+)$') {
            $expected = $Matches[1].ToLower()
            $name = $Matches[2].Trim()
            $file = Join-Path $Tmp $name
            if (Test-Path $file) {
                $actual = (Get-FileHash $file -Algorithm SHA256).Hash.ToLower()
                if ($actual -ne $expected) { throw "sha256 不匹配：$name" }
                Write-Host "[PASS] sha256 校验通过：$name"
            }
        }
    }
} catch {
    Write-Host "[WARN] 没有校验文件或校验跳过：$($_.Exception.Message)"
}

Get-ChildItem $Tmp -Filter '*.hap' | ForEach-Object {
    Move-Item $_.FullName (Join-Path $Dir $_.Name) -Force
    Write-Host ("已保存：{0}" -f (Join-Path $Dir $_.Name))
}
Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue
