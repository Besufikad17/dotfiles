
-- LSP configuration

-- IMPORTANT: this needs to be set up before LSP.
require("neodev").setup({})

-- LSP Saga config
require("lspsaga").setup({
  lightbulb = {
    virtual_text = false,
  },
})

-- LSP Event Autocommands
local lsp_events = vim.api.nvim_create_augroup("EpicLspEvents", { clear = true, })

-- Format using LSP
local format_pre_save = function()
  -- pcall() suppresses errors when the LSP server does not support formatting
  -- (hopefully no other errors occur, as those will be suppressed as well.)
  pcall(vim.lsp.buf.format)
end

--- Format using formatter.nvim
local function format_write()
  vim.cmd("FormatWrite")
end

-- Formatter.nvim
require("formatter").setup({
  filetype = {
    css = {
      require("formatter.filetypes.css").prettier,
    },
    htmldjango = {
      function()
        return {
          exe = "djlint",
          args = {
            "--reformat",
            "--indent=2",
            "-",
          },
          stdin = true,
        }
      end,
    },
    javascript = {
      require("formatter.filetypes.javascript").prettier,
    },
    vue = {
      require("formatter.filetypes.vue").prettier,
    },
  },
})

-- nvim-lint
require("lint").linters_by_ft = {
  htmldjango = { "djlint" },
}

-- Shared config
local on_attach = function(client, bufnr)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0, desc = "LSP Hover" })
  vim.keymap.set("n", "gN", vim.diagnostic.goto_next, { buffer = 0, desc = "LSP Next Diagnostic" })
  vim.keymap.set("n", "gP", vim.diagnostic.goto_prev, { buffer = 0, desc = "LSP Previous Diagnostic" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0, desc = "LSP Go To Definition" })

  require("lsp_signature").on_attach({}, bufnr)

  -- Only enable this when the LS supports formatting.
  local filetype = vim.filetype.match({ buf = bufnr })

  if filetype == "htmldjango" then
    -- Prevent neovim from defining these multiple times with multiple LSP servers
    if not vim.b.has_djlint then
      vim.b.has_djlint = true
      -- Lint before events get triggered since BufEnter doesn't work
      require("lint").try_lint()
      -- Enable linting
      vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        callback = function()
          require("lint").try_lint()
        end,
        group = lsp_events,
        buffer = 0,
        desc = "Linst htmldjango file",
      })
      -- Enable autoformat
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = format_write,
        group = lsp_events,
        buffer = 0,
        desc = "Call djlint using formatter.nvim",
      })
    end
    return
  end

  if (filetype == "css") or (filetype == "javascript") or (filetype == "vue") then
    -- Prevent neovim from defining this autocmd multiple times with multiple LSP servers
    if not vim.b.has_prettier then
      vim.b.has_prettier = true
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = format_write,
        group = lsp_events,
        buffer = 0,
        desc = "Call prettier using formatter.nvim",
      })
    end
    return
  end

  -- TODO: find linters for these languaes
  if (filetype == "yaml") or (filetype == "yaml.ansible") then return end

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = format_pre_save,
    group = lsp_events,
    buffer = 0,
    desc = "Format before saving if LSP is attached",
  })
end

-- Emmet for HTML, Django, and other fun stuff
require "lspconfig".emmet_ls.setup {
  on_attach = on_attach,
  cmd = { "npx", "--prefix", "{{ user_home_dir }}/.local/epic_npm/", "emmet-ls", "--stdio" },
  filetypes = { "css", "html", "htmldjango", "vue" }
}

-- Ansible
require "lspconfig".ansiblels.setup {
  on_attach = on_attach,
  cmd = { "npx", "--prefix", "{{ user_home_dir }}/.local/epic_npm/", "ansible-language-server", "--stdio" },
}

-- Docker
require "lspconfig".dockerls.setup {
  on_attach = on_attach,
  cmd = { "npx", "--prefix", "{{ user_home_dir }}/.local/epic_npm/", "docker-langserver", "--stdio" },
}

-- Golang
require "lspconfig".gopls.setup {
  on_attach = on_attach,
}

-- JS
require "lspconfig".tsserver.setup {
  on_attach = on_attach
}

-- Lua
require "lspconfig".lua_ls.setup {
  settings = {
    Lua = {
      semantic = {
        -- Disable this crap that overrides the theme
        enable = false,
      },
      format = {
        -- Enable code formatting
        enable = true,
      },
      runtime = {
        -- Default to the version of Lua built into neovim
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the server to recognize the vim global
        globals = { "vim" }
      },
      workspace = {
        -- Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- Disable third party checking to stop annoying prompts when opening lua files
        checkThirdParty = false,
      },
      telemetry = {
        -- Don't send telemetry data
        enabled = false
      }
    }
  },
  on_attach = on_attach
}

-- Python
require "lspconfig".pylsp.setup {
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        black = {
          cache_config = true,
          enabled = true,
          line_length = 119,
        },
        flake8 = {
          enabled = true,
          maxLineLength = 119,
        },
        mypy = {
          enabled = true,
        },
        pycodestyle = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
      }
    }
  }
}

-- Tailwind CSS
require "lspconfig".tailwindcss.setup {
  on_attach = on_attach,
  cmd = { "npx", "--prefix", "{{ user_home_dir }}/.local/epic_npm/", "tailwindcss-language-server", "--stdio" },
}

-- Vue.js
require "lspconfig".volar.setup {
  on_attach = on_attach,
  cmd = { "npx", "--prefix", "{{ user_home_dir }}/.local/epic_npm/", "vue-language-server", "--stdio" },
  filetypes = { "vue" },
}

-- YAML
require "lspconfig".yamlls.setup {
  on_attach = on_attach,
  filetypes = { "yaml", "yaml.ansible" },
  settings = {
    yaml = {
      schemas = {
        kubernetes = { "/deploy/*.yml", "/deploy/*.yaml" },
      },
    },
  },
}
