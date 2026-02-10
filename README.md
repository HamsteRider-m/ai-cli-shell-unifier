# Windows AI CLI UTF-8 Shell Shims

A reusable Windows setup to make AI coding CLIs more stable with UTF-8 and PowerShell 7.

## What This Solves

Many AI CLIs on Windows run shell commands through `powershell.exe -NoProfile`, which often causes:

- encoding mismatches
- shell differences across tools
- short default shell timeout behavior

This repo provides lightweight command shims and an installer that standardize:

- UTF-8 process defaults
- `ComSpec`/`COMSPEC`/`SHELL` pointing to PowerShell 7
- `chcp 65001` in shim-invoked sessions
- common Claude timeout environment defaults
- Gemini shell inactivity timeout setting

## Included Shims

- `claude`
- `codex`
- `gemini`
- `opencode`

Each shim delegates to the real command under `%USERPROFILE%\AppData\Roaming\npm\*.cmd`.

## Repository Layout

- `shims/common-env.cmd`: shared UTF-8 and shell environment setup
- `shims/*.cmd`: CLI wrappers
- `shims/add-shim.ps1`: generate wrappers for additional npm-installed CLIs
- `scripts/install.ps1`: install shims and update user-level settings
- `scripts/uninstall.ps1`: remove PATH integration and optional files
- `scripts/verify.ps1`: quick health check

## Install

Run from this repo root:

```powershell
pwsh -File .\scripts\install.ps1
```

Optional custom install directory:

```powershell
pwsh -File .\scripts\install.ps1 -InstallDir "C:\Users\<you>\tools\ai-cli-shims"
```

After install, restart terminal/IDE sessions.

## Add Another CLI Shim

Example for a CLI named `aider` installed via npm:

```powershell
pwsh -File .\shims\add-shim.ps1 -CommandName aider
```

Then copy the generated wrapper from `shims\aider.cmd` to your install directory, or rerun install.

If the target command is not in `%USERPROFILE%\AppData\Roaming\npm`, pass `-TargetCmdPath`.

## Verify

```powershell
pwsh -File .\scripts\verify.ps1
```

You should see shim paths first in `where` output.

## Uninstall

```powershell
pwsh -File .\scripts\uninstall.ps1
```

To also delete installed shim files:

```powershell
pwsh -File .\scripts\uninstall.ps1 -RemoveInstallDir
```

## Known Limits

- This setup cannot intercept tools that hardcode an absolute call to `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`.
- For those tools, configure shell path in the tool itself or make called scripts self-configure UTF-8.

## License

MIT. See `LICENSE`.
