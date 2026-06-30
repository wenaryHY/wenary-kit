param(
    [string]$ConfigDir = "$env:USERPROFILE\.config\opencode",
    [string]$HaloProjectDir = "D:\codes\IJProject\Halo",
    [switch]$DryRun
)

$KitDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BackupDir = "$ConfigDir\.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

$Created = 0
$Skipped = 0
$Errors = 0

# 检查符号链接支持
function Test-SymlinkSupport {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) { return $true }

    $devMode = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
    if ($devMode.AllowDevelopmentWithoutDevLicense -eq 1) { return $true }

    return $false
}

if (-not (Test-SymlinkSupport)) {
    Write-Host ""
    Write-Host "符号链接需要管理员权限或启用开发人员模式(Developer Mode)。" -ForegroundColor Yellow
    Write-Host "请以管理员身份运行此脚本，或启用开发人员模式：" -ForegroundColor Yellow
    Write-Host "  设置 -> 隐私和安全性 -> 开发人员模式 -> 开" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "或者使用 -DryRun 查看将要链接的文件列表。" -ForegroundColor Gray
    exit 1
}

function New-Symlink {
    param($Source, $Target, $BackupDir, $DryRun)

    if (Test-Path -LiteralPath $Target) {
        $item = Get-Item -LiteralPath $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            $resolved = (Resolve-Path -LiteralPath $Target -ErrorAction SilentlyContinue).Path
            if ($resolved -eq (Resolve-Path -LiteralPath $Source -ErrorAction SilentlyContinue).Path) {
                return "skipped"
            }
        }
        if (-not $DryRun) {
            $relPath = $Target.Substring($ConfigDir.Length).TrimStart('\')
            $backupFile = Join-Path $BackupDir $relPath
            $backupDir = Split-Path -Parent $backupFile
            New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
            Move-Item -LiteralPath $Target -Destination $backupFile -Force
            Write-Host "  Backed up: $relPath" -ForegroundColor DarkYellow
        }
    } else {
        $tgtDir = Split-Path -Parent $Target
        if (-not (Test-Path -LiteralPath $tgtDir)) {
            if (-not $DryRun) {
                New-Item -ItemType Directory -Force -Path $tgtDir | Out-Null
            }
        }
    }

    if (-not $DryRun) {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
        Write-Host "  Symlinked: $($Target.Substring($ConfigDir.Length).TrimStart('\'))" -ForegroundColor Green
    } else {
        Write-Host "  Would link: $Source -> $Target"
    }

    return "created"
}

# 需要同步的映射关系
$Mappings = @(
    @{Source = "$KitDir\agents\global"; Target = "$ConfigDir\agents"}
    @{Source = "$KitDir\config\AGENTS.md"; Target = "$ConfigDir\AGENTS.md"}
    @{Source = "$KitDir\context\docs"; Target = "$ConfigDir\context\docs"}
    @{Source = "$KitDir\agents\project-templates\halo"; Target = "$HaloProjectDir\.opencode\agents"}
)

foreach ($m in $Mappings) {
    $Source = $m.Source
    $Target = $m.Target

    if (Test-Path -LiteralPath $Source -PathType Container) {
        Get-ChildItem -Path $Source -File | ForEach-Object {
            $result = New-Symlink -Source $_.FullName -Target (Join-Path $Target $_.Name) -BackupDir $BackupDir -DryRun:$DryRun
            if ($result -eq "created") { $Created++ }
            elseif ($result -eq "skipped") { $Skipped++ }
            else { $Errors++ }
        }
    } elseif (Test-Path -LiteralPath $Source -PathType Leaf) {
        $result = New-Symlink -Source $Source -Target $Target -BackupDir $BackupDir -DryRun:$DryRun
        if ($result -eq "created") { $Created++ }
        elseif ($result -eq "skipped") { $Skipped++ }
        else { $Errors++ }
    } else {
        Write-Warning "Source not found: $Source"
        $Errors++
    }
}

if (-not $DryRun) {
    Write-Host ""
    Write-Host "Done: $Created created, $Skipped skipped, $Errors errors" -ForegroundColor Cyan
    if (Test-Path $BackupDir) {
        Write-Host "Backup saved to: $BackupDir" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "Dry run: $Created would be created, $Skipped would be skipped" -ForegroundColor Cyan
}
