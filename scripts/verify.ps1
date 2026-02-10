param(
    [string]$InstallDir = "$env:USERPROFILE\tools\ai-cli-shims"
)

$ErrorActionPreference = 'Stop'

Write-Host "=== PATH Check ==="
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -like "$InstallDir;*") {
    Write-Host "OK: install dir is first in user PATH"
} elseif ($userPath -like "*;$InstallDir;*" -or $userPath -like "*;$InstallDir") {
    Write-Host "WARN: install dir exists in PATH but is not first"
} else {
    Write-Host "WARN: install dir not found in user PATH"
}

Write-Host ""
Write-Host "=== Command Resolution (current process) ==="
$env:Path = "$InstallDir;$env:Path"
foreach ($name in @('claude','codex','gemini','opencode')) {
    Write-Host "-- $name --"
    & where.exe $name
}

Write-Host ""
Write-Host "=== User Env ==="
foreach ($name in @('PYTHONUTF8','PYTHONIOENCODING','CLAUDE_CODE_SHELL','BASH_DEFAULT_TIMEOUT_MS','BASH_MAX_TIMEOUT_MS','CLAUDE_BASH_NO_LOGIN')) {
    $value = [Environment]::GetEnvironmentVariable($name, 'User')
    Write-Host "$name=$value"
}

Write-Host ""
Write-Host "=== Version Smoke Test ==="
& claude --version
& codex --version
& gemini --version
& opencode --version
