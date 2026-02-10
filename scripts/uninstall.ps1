param(
    [string]$InstallDir = "$env:USERPROFILE\tools\ai-cli-shims",
    [switch]$RemoveInstallDir
)

$ErrorActionPreference = 'Stop'

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath) {
    $parts = $userPath -split ';' | Where-Object { $_ -and $_.Trim() -ne '' -and $_ -ne $InstallDir }
    [Environment]::SetEnvironmentVariable('Path', ($parts -join ';'), 'User')
    Write-Host "Removed install dir from user PATH if present"
}

[Environment]::SetEnvironmentVariable('CLAUDE_CODE_SHELL', $null, 'User')
[Environment]::SetEnvironmentVariable('BASH_DEFAULT_TIMEOUT_MS', $null, 'User')
[Environment]::SetEnvironmentVariable('BASH_MAX_TIMEOUT_MS', $null, 'User')
[Environment]::SetEnvironmentVariable('CLAUDE_BASH_NO_LOGIN', $null, 'User')

if ($RemoveInstallDir -and (Test-Path $InstallDir)) {
    Remove-Item -Path $InstallDir -Recurse -Force
    Write-Host "Removed install directory: $InstallDir"
}

Write-Host "Uninstall complete. Restart your terminal and IDE sessions."
