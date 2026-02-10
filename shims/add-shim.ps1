param(
    [Parameter(Mandatory = $true)][string]$CommandName,
    [string]$TargetCmdPath
)

$ErrorActionPreference = 'Stop'
$shimDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $TargetCmdPath) {
    $TargetCmdPath = Join-Path $env:USERPROFILE "AppData\Roaming\npm\$CommandName.cmd"
}

$wrapper = @"
@echo off
call "%~dp0common-env.cmd"

set "REAL_CMD=$TargetCmdPath"
if not exist "%REAL_CMD%" (
  echo $CommandName shim target not found at "%REAL_CMD%"
  exit /b 1
)

call "%REAL_CMD%" %*
set "_code=%ERRORLEVEL%"
exit /b %_code%
"@

$wrapperPath = Join-Path $shimDir ("{0}.cmd" -f $CommandName)
Set-Content -Path $wrapperPath -Value $wrapper -Encoding Ascii
Write-Host "Created $wrapperPath"
