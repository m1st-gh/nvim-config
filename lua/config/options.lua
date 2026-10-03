vim.o.clipboard = "unnamedplus"

-- PowerShell as the default shell
vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh.exe" or "powershell.exe"
vim.o.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""

vim.g.snacks_animate = false

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font Propo:h12"
end

if vim.g.vscode then
  vim.o.scroll = 0 -- Native Ctrl-D / Ctrl-U use half the window height.
end

vim.g.root_spec = { "cwd", "lsp" }
