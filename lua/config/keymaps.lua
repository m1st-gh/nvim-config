-- Keymaps are loaded on VeryLazy
-- Default LazyVim keymaps:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- ============================================================================
-- DISABLE HELP
-- ============================================================================

map({ "n", "i", "v", "x", "s", "c", "o", "t" }, "<F1>", "<Nop>", { silent = true })
map({ "n", "i", "v" }, "<Help>", "<Nop>", { silent = true })

-- ============================================================================
-- WINDOW RESIZING
-- ============================================================================

local function vertical_resize(edge, other)
  if vim.fn.winnr() == vim.fn.winnr("l") then
    vim.cmd("vertical resize " .. edge)
  else
    vim.cmd("vertical resize " .. other)
  end
end

local function horizontal_resize(bottom, other)
  if vim.fn.winnr() == vim.fn.winnr("j") then
    vim.cmd("resize " .. bottom)
  else
    vim.cmd("resize " .. other)
  end
end

map("n", "<C-Left>", function()
  vertical_resize("+2", "-2")
end, { desc = "Move Border Left" })

map("n", "<C-Right>", function()
  vertical_resize("-2", "+2")
end, { desc = "Move Border Right" })

map("n", "<C-Up>", function()
  horizontal_resize("+2", "-2")
end, { desc = "Move Border Up" })

map("n", "<C-Down>", function()
  horizontal_resize("-2", "+2")
end, { desc = "Move Border Down" })

-- ============================================================================
-- DAP
-- ============================================================================

local dap = require("dap")

map("n", "<F5>", dap.continue, { desc = "DAP Continue" })
map("n", "<S-F5>", dap.run_last, { desc = "DAP Run Last" })
map("n", "<F6>", dap.pause, { desc = "DAP Pause" })
map("n", "<F8>", dap.run_to_cursor, { desc = "DAP Run To Cursor" })
map("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
map("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
map("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
map("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })

map("n", "<S-F9>", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP Conditional Breakpoint" })

-- ============================================================================
-- EASY-DOTNET
-- ============================================================================

local dotnet = require("easy-dotnet")
local wk = require("which-key")

local function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

-- ============================================================================
-- WHICH-KEY GROUPS
-- ============================================================================

wk.add({
  { "<leader>z", group = "Dotnet" },
  { "<leader>zb", group = "Build / Pack" },
  { "<leader>zd", group = "Debug" },
  { "<leader>ze", group = "Entity Framework" },
  { "<leader>zr", group = "Run / Watch" },
  { "<leader>zs", group = "Solution & Packages" },
  { "<leader>zt", group = "Testing" },
})

-- ============================================================================
-- RUN / WATCH
-- ============================================================================

nmap("<leader>zrr", dotnet.run, "Run Project")
nmap("<leader>zrd", dotnet.run_default, "Run Default Project")
nmap("<leader>zrp", dotnet.run_profile, "Run Profile")
nmap("<leader>zrm", dotnet.run_profile_default, "Run Default Profile")
nmap("<leader>zrw", dotnet.watch, "Watch Project")
nmap("<leader>zrx", dotnet.watch_default, "Watch Default Project")

-- ============================================================================
-- DEBUG
-- ============================================================================

nmap("<leader>zdd", dotnet.debug, "Debug Project")
nmap("<leader>zda", dotnet.debug_attach, "Attach Debugger")
nmap("<leader>zdf", dotnet.debug_default, "Debug Default Project")
nmap("<leader>zdp", dotnet.debug_profile, "Debug Profile")
nmap("<leader>zdm", dotnet.debug_profile_default, "Debug Default Profile")

-- ============================================================================
-- BUILD / PACK
-- ============================================================================

nmap("<leader>zbb", dotnet.build, "Build Project")
nmap("<leader>zbs", dotnet.build_solution, "Build Solution")
nmap("<leader>zbq", dotnet.build_quickfix, "Build Project To Quickfix")
nmap("<leader>zbx", dotnet.build_solution_quickfix, "Build Solution To Quickfix")
nmap("<leader>zbd", dotnet.build_default, "Build Default Project")
nmap("<leader>zbf", dotnet.build_default_quickfix, "Build Default Project To Quickfix")
nmap("<leader>zbk", dotnet.pack, "Pack Project")
nmap("<leader>zbp", dotnet.push, "Pack And Push")

-- ============================================================================
-- TESTING
-- ============================================================================

nmap("<leader>ztt", dotnet.test, "Test Project")
nmap("<leader>zts", dotnet.test_solution, "Test Solution")
nmap("<leader>ztd", dotnet.test_default, "Test Default Project")
nmap("<leader>ztr", dotnet.testrunner, "Toggle Test Runner")

-- ============================================================================
-- SOLUTIONS & PACKAGES
-- ============================================================================

nmap("<leader>zsa", dotnet.add_package, "Add NuGet Package")
nmap("<leader>zsr", dotnet.remove_package, "Remove NuGet Package")
nmap("<leader>zso", dotnet.outdated, "Check Outdated Packages")
nmap("<leader>zsl", dotnet.restore, "Restore Solution")
nmap("<leader>zss", dotnet.solution_select, "Select Solution")
nmap("<leader>zs+", dotnet.solution_add, "Add Project To Solution")
nmap("<leader>zs-", dotnet.solution_remove, "Remove Project From Solution")

-- ============================================================================
-- ENTITY FRAMEWORK
-- ============================================================================

map("n", "<leader>zea", function()
  vim.ui.input({ prompt = "Migration name: " }, function(name)
    if name and name ~= "" then
      dotnet.ef_migrations_add(name)
    end
  end)
end, { desc = "Add Migration" })

nmap("<leader>zer", dotnet.ef_migrations_remove, "Remove Last Migration")
nmap("<leader>zel", dotnet.ef_migrations_list, "List Migrations")
nmap("<leader>zeu", dotnet.ef_database_update, "Update Database")
nmap("<leader>zep", dotnet.ef_database_update_pick, "Update Database To Selected Migration")

-- ============================================================================
-- EASY-DOTNET TEST RUNNER
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "easy-dotnet-test-runner",
  callback = function(args)
    local buf = args.buf

    local function buf_map(lhs, desc, fn)
      vim.keymap.set("n", lhs, fn, {
        buffer = buf,
        desc = desc,
        silent = true,
        noremap = true,
        nowait = true,
      })
    end

    buf_map("gt", "Go To Source", function()
      local render = require("easy-dotnet.test-runner.render")
      local state = require("easy-dotnet.test-runner.state")
      local logger = require("easy-dotnet.logger")

      local node = render.node_at_cursor()

      if not node then
        return
      end

      if not state.has_action(node, "GoToSource") then
        logger.warn("No source location available")
        return
      end

      if not node.filePath then
        return
      end

      render.hide()

      vim.cmd("edit " .. vim.fn.fnameescape(node.filePath))

      if node.bodyStartLine then
        vim.api.nvim_win_set_cursor(0, { node.bodyStartLine + 1, 0 })
      end
    end)

    buf_map("o", "Toggle Expand", function()
      local render = require("easy-dotnet.test-runner.render")
      local node = render.node_at_cursor()

      if node then
        node.expanded = not node.expanded
        render.refresh()
      end
    end)
  end,
})

-- ============================================================================
-- CODECOMPANION
-- ============================================================================

-- Chat
map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", {
  desc = "AI Chat Toggle",
})

map("n", "<leader>an", "<cmd>CodeCompanionChat<cr>", {
  desc = "AI New Chat",
})

map("n", "<leader>ar", "<cmd>CodeCompanionChat<cr>", {
  desc = "AI Resume Chat",
})

-- Actions
map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", {
  desc = "AI Actions",
})

map("v", "<leader>ai", "<cmd>CodeCompanion<cr>", {
  desc = "AI Inline Transform",
})

map("v", "<leader>ae", "<cmd>CodeCompanionChat Add<cr>", {
  desc = "AI Add Selection",
})

-- Context & Slash Commands (Directly calling commands as arguments)
map("n", "<leader>ab", "<cmd>CodeCompanionChat /buffer<cr>", {
  desc = "AI Add Current Buffer",
})

map("n", "<leader>af", "<cmd>CodeCompanionChat /file<cr>", {
  desc = "AI Add File",
})

map("n", "<leader>aB", "<cmd>CodeCompanionChat /buffer<cr>", {
  desc = "AI Add Buffers",
})

map("v", "<leader>av", "<cmd>CodeCompanionChat Add<cr>", {
  desc = "AI Add Visual Selection",
})

map("n", "<leader>ah", "<cmd>CodeCompanionChat /help<cr>", {
  desc = "AI Help",
})

map("n", "<leader>as", "<cmd>CodeCompanionChat /symbols<cr>", {
  desc = "AI Symbols",
})

map("n", "<leader>ax", "<cmd>CodeCompanionChat /compact<cr>", {
  desc = "AI Compact Chat",
})

map("n", "<leader>ap", "<cmd>CodeCompanionChat /prompt<cr>", {
  desc = "AI Prompt Library",
})

map("n", "<leader>ao", "<cmd>CodeCompanionChat /resume<cr>", {
  desc = "AI Resume Saved Chat",
})
