param(
    [string]$InstallDir = "$env:USERPROFILE\tools\ai-cli-shims",
    [switch]$SkipGeminiSettings
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceShims = Join-Path $repoRoot 'shims'

if (-not (Test-Path $sourceShims)) {
    throw "Shims directory not found: $sourceShims"
}

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Copy-Item (Join-Path $sourceShims '*') $InstallDir -Force

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$pathParts = @()
if ($userPath) {
    $pathParts = $userPath -split ';' | Where-Object { $_ -and $_.Trim() -ne '' }
}
if (-not ($pathParts -contains $InstallDir)) {
    $newPath = @($InstallDir) + $pathParts
    [Environment]::SetEnvironmentVariable('Path', ($newPath -join ';'), 'User')
    Write-Host "Prepended install dir to user PATH"
} else {
    Write-Host "Install dir already present in user PATH"
}

$pwshPath = 'C:\Program Files\PowerShell\7\pwsh.exe'
if (-not (Test-Path $pwshPath)) {
    $pwshPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
}

[Environment]::SetEnvironmentVariable('PYTHONUTF8', '1', 'User')
[Environment]::SetEnvironmentVariable('PYTHONIOENCODING', 'utf-8', 'User')
[Environment]::SetEnvironmentVariable('CLAUDE_CODE_SHELL', $pwshPath, 'User')
[Environment]::SetEnvironmentVariable('BASH_DEFAULT_TIMEOUT_MS', '120000', 'User')
[Environment]::SetEnvironmentVariable('BASH_MAX_TIMEOUT_MS', '600000', 'User')
[Environment]::SetEnvironmentVariable('CLAUDE_BASH_NO_LOGIN', '1', 'User')

if (-not $SkipGeminiSettings) {
    $geminiSettingsPath = Join-Path $env:USERPROFILE '.gemini\settings.json'
    if (Test-Path $geminiSettingsPath) {
        try {
            $json = Get-Content -Raw $geminiSettingsPath | ConvertFrom-Json
            if (-not $json.tools) {
                $json | Add-Member -NotePropertyName tools -NotePropertyValue ([pscustomobject]@{})
            }
            if (-not $json.tools.shell) {
                $json.tools | Add-Member -NotePropertyName shell -NotePropertyValue ([pscustomobject]@{})
            }
            $shell = $json.tools.shell
            if ($shell.PSObject.Properties.Name -contains 'enableInteractiveShell') {
                $shell.enableInteractiveShell = $true
            } else {
                $shell | Add-Member -NotePropertyName enableInteractiveShell -NotePropertyValue $true
            }
            if ($shell.PSObject.Properties.Name -contains 'inactivityTimeout') {
                $shell.inactivityTimeout = 1200
            } else {
                $shell | Add-Member -NotePropertyName inactivityTimeout -NotePropertyValue 1200
            }
            if ($shell.PSObject.Properties.Name -contains 'showColor') {
                $shell.showColor = $true
            } else {
                $shell | Add-Member -NotePropertyName showColor -NotePropertyValue $true
            }
            $json | ConvertTo-Json -Depth 100 | Set-Content -Path $geminiSettingsPath -Encoding utf8
            Write-Host "Updated Gemini settings: $geminiSettingsPath"
        } catch {
            Write-Warning "Failed to update Gemini settings: $($_.Exception.Message)"
        }
    } else {
        Write-Host "Gemini settings file not found, skipped: $geminiSettingsPath"
    }
}

Write-Host "Install complete. Restart your terminal and IDE sessions."
Write-Host "Run verify with: pwsh -File `"$repoRoot\scripts\verify.ps1`""
