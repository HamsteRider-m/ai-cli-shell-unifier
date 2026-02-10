@echo off
call "%~dp0common-env.cmd"

set "REAL_CMD=%USERPROFILE%\AppData\Roaming\npm\opencode.cmd"
if not exist "%REAL_CMD%" (
  echo opencode shim target not found at "%REAL_CMD%"
  exit /b 1
)

call "%REAL_CMD%" %*
set "_code=%ERRORLEVEL%"
exit /b %_code%
