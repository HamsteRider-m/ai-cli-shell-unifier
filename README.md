# Windows AI CLI UTF-8 Shell Shims

English | 中文

---

## English

A reusable Windows setup to make AI coding CLIs more stable with UTF-8 and PowerShell 7.

### What This Solves

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

### Included Shims

- `claude`
- `codex`
- `gemini`
- `opencode`

Each shim delegates to the real command under `%USERPROFILE%\AppData\Roaming\npm\*.cmd`.

### Repository Layout

- `shims/common-env.cmd`: shared UTF-8 and shell environment setup
- `shims/*.cmd`: CLI wrappers
- `shims/add-shim.ps1`: generate wrappers for additional npm-installed CLIs
- `scripts/install.ps1`: install shims and update user-level settings
- `scripts/uninstall.ps1`: remove PATH integration and optional files
- `scripts/verify.ps1`: quick health check

### Install

Run from repo root:

```powershell
pwsh -File .\scripts\install.ps1
```

Optional custom install directory:

```powershell
pwsh -File .\scripts\install.ps1 -InstallDir "C:\Users\<you>\tools\ai-cli-shims"
```

After install, restart terminal/IDE sessions.

### Add Another CLI Shim

Example for a CLI named `aider` installed via npm:

```powershell
pwsh -File .\shims\add-shim.ps1 -CommandName aider
```

If the target command is not in `%USERPROFILE%\AppData\Roaming\npm`, pass `-TargetCmdPath`.

### Verify

```powershell
pwsh -File .\scripts\verify.ps1
```

You should see shim paths first in `where` output.

### Uninstall

```powershell
pwsh -File .\scripts\uninstall.ps1
```

To also delete installed shim files:

```powershell
pwsh -File .\scripts\uninstall.ps1 -RemoveInstallDir
```

### Known Limits

- This setup cannot intercept tools that hardcode an absolute call to `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`.
- For those tools, configure shell path in the tool itself or make called scripts self-configure UTF-8.

---

## 中文

这是一个可复用的 Windows 方案，用于把常见 AI CLI 的 shell 行为统一到 UTF-8 和 PowerShell 7。

### 解决的问题

很多 AI CLI 在 Windows 下会用 `powershell.exe -NoProfile` 执行命令，常见后果是：

- 编码不一致（中文乱码、日志乱码）
- 不同工具 shell 行为不一致
- 默认超时过短导致任务中断

本仓库通过轻量 shim 和安装脚本，统一以下行为：

- 进程默认 UTF-8
- `ComSpec`/`COMSPEC`/`SHELL` 指向 PowerShell 7
- shim 会话中执行 `chcp 65001`
- Claude 常用超时环境变量默认值
- Gemini shell 空闲超时设置

### 已内置的 shim

- `claude`
- `codex`
- `gemini`
- `opencode`

每个 shim 会转发到 `%USERPROFILE%\AppData\Roaming\npm\*.cmd` 的真实命令。

### 目录结构

- `shims/common-env.cmd`：共享环境设置（UTF-8 + shell）
- `shims/*.cmd`：CLI 包装器
- `shims/add-shim.ps1`：为其他 npm CLI 生成包装器
- `scripts/install.ps1`：安装并写入用户级配置
- `scripts/uninstall.ps1`：卸载并清理 PATH 关联
- `scripts/verify.ps1`：快速自检

### 安装

在仓库根目录执行：

```powershell
pwsh -File .\scripts\install.ps1
```

可选自定义安装目录：

```powershell
pwsh -File .\scripts\install.ps1 -InstallDir "C:\Users\<你>\tools\ai-cli-shims"
```

安装后请重启终端或 IDE 会话。

### 添加新的 CLI 包装器

以 `aider` 为例：

```powershell
pwsh -File .\shims\add-shim.ps1 -CommandName aider
```

如果目标命令不在 `%USERPROFILE%\AppData\Roaming\npm`，可传 `-TargetCmdPath`。

### 验证

```powershell
pwsh -File .\scripts\verify.ps1
```

`where` 输出中应优先命中 shim 路径。

### 卸载

```powershell
pwsh -File .\scripts\uninstall.ps1
```

如需同时删除安装目录：

```powershell
pwsh -File .\scripts\uninstall.ps1 -RemoveInstallDir
```

### 已知限制

- 无法拦截“硬编码绝对路径调用” `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` 的工具。
- 这类工具建议在其自身配置中指定 shell，或在被调用脚本内部显式设置 UTF-8。

---

## License

MIT. See `LICENSE`.
