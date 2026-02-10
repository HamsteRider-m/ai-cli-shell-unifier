@echo off
if defined __AI_CLI_ENV_APPLIED exit /b 0
set "__AI_CLI_ENV_APPLIED=1"

set "PWSH_EXE=C:\Program Files\PowerShell\7\pwsh.exe"
if not exist "%PWSH_EXE%" set "PWSH_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

set "ComSpec=%PWSH_EXE%"
set "COMSPEC=%PWSH_EXE%"
set "SHELL=%PWSH_EXE%"

set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
set "LANG=en_US.UTF-8"
set "LC_ALL=en_US.UTF-8"

chcp 65001 >nul
exit /b 0
