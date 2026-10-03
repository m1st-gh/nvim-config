return {
  {
    "danymat/neogen",
    opts = {
      languages = {
        python = {
          template = {
            annotation_convention = "numpydoc",
          },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },

  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      terminal = "toggleterm",
      lsp = {
        auto_refresh_codelens = false,
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },

  {
    "tummetott/reticle.nvim",
    event = "VeryLazy",
    opts = {
      ignore = {
        cursorline = { "snacks_dashboard" },
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      options = {
        shell = {
          shell = "cmd.exe",
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },

        per_filetype = {
          codecompanion = {
            "codecompanion",
          },
        },

        transform_items = function(_, items)
          for _, item in ipairs(items) do
            if item.label then
              item.label = item.label:gsub("\r", "")
            end

            if item.detail then
              item.detail = item.detail:gsub("\r", "")
            end

            if item.textEdit and item.textEdit.newText then
              item.textEdit.newText = item.textEdit.newText:gsub("\r", "")
            end

            if item.insertText then
              item.insertText = item.insertText:gsub("\r", "")
            end
          end

          return items
        end,
      },
    },
  },

  {
    "nemanjamalesija/smart-paste.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "m1st-gh/codecompanion-pwsh.nvim",
    branch = "pwsh",
    event = "VeryLazy",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local adapters = require("codecompanion.adapters")

      require("codecompanion").setup({
        interactions = {
          chat = {
            adapter = "local-ai",
            tools = {
              opts = {
                approval_mode = "auto",
                default_tools = { "agent" },
              },
            },
          },
          inline = {
            adapter = "local-ai",
          },
        },

        opts = {
          system_prompt = function(ctx)
            local extra = [[

You are running inside Neovim on Windows. Use PowerShell commands that are
compatible with Windows. Do not provide Bash, Linux, or macOS shell commands.

Prefer native PowerShell cmdlets such as Get-ChildItem, Select-String,
Get-Content, and Set-Content instead of Unix utilities.
]]
            -- Append to the default prompt when the version exposes it
            return ((ctx and ctx.default_system_prompt) or "You are an AI coding assistant.") .. extra
          end,
        },

        adapters = {
          http = {
            ["local-ai"] = function()
              return adapters.extend("openai_responses", {
                url = "http://localhost:8000/v1/responses",
                env = { api_key = "TERM" },
                opts = { stream = false },
                features = { tools = true },
                schema = {
                  model = {
                    default = "gpt-5.6-sol",
                    opts = { has_choices = false },
                  },
                },
              })
            end,
          },
        },
      })
    end,
  },
}
