@echo off
call "%~dp0common-env.cmd"

set "CLAUDE_CODE_SHELL=%PWSH_EXE%"
set "BASH_DEFAULT_TIMEOUT_MS=120000"
set "BASH_MAX_TIMEOUT_MS=600000"
set "CLAUDE_BASH_NO_LOGIN=1"

set "REAL_CMD=%USERPROFILE%\AppData\Roaming\npm\claude.cmd"
if not exist "%REAL_CMD%" (
  echo claude shim target not found at "%REAL_CMD%"
  exit /b 1
)

call "%REAL_CMD%" %*
set "_code=%ERRORLEVEL%"
exit /b %_code%
