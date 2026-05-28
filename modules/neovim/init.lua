-- =========================
-- Basic editor settings
-- =========================

-- LINE NUMBERS
vim.opt.number = true
vim.opt.relativenumber = true

-- IDENTATION & SPACING
vim.opt.expandtab = true
vim.opt.shiftwidth = 2 
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
-- UI & FEELING
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
-- SEARCH BEHAVIOR
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
-- -------------------------
-- LEADER KEY & CORE KEYMAPS
-- -------------------------
-- SET SPACEBAR AS THE LEADER KEY

-- ==========================
-- NATIVE COMPLETION ENGINE
-- ==========================
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c")


-- =======================
-- NIX AUTO-FORMAT on SAVE
-- =======================
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.nix",
  callback = function ()
  local formatter = "nixfmt"

  if vim.fn.executable(formatter) == 1 then
    local current_view = vim.fn.winsaveview()
    vim.cmd("%!" .. formatter)
    vim.fn.winrestview(current_view)
  end
end,
desc = "Automatically format Nix files on save using RFS style",
})



-- =========================
-- Nix LSP (nil)
-- =========================
local nil_cmd = { "nil" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    -- جلوگیری از چندبار اجرا شدن LSP
    if vim.lsp.get_clients({ name = "nil", bufnr = 0 })[1] then
      return
    end

    -- Root detection (flake.nix → .git → fallback cwd)
    local root = vim.fs.find({ "flake.nix", ".git" }, { upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()

    vim.lsp.start({
      name = "nil",
      cmd = nil_cmd,
      root_dir = root,

      -- Optional but recommended
      settings = {
        ["nil"] = {
          formatting = {
            command = { "nixfmt" }, -- or "alejandra"
          },
        },
      },

      on_attach = function(client, bufnr)
        -- Enable LSP formatting
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end, { buffer = bufnr, desc = "Format file" })
        end
      end,
    })
  end,
})

-- =========================
-- Autoformat on save
-- =========================
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.nix",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})


-- =========================
-- Rust LSP (rust-analyzer)
-- =========================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    -- Prevent starting multiple LSP clients for the same buffer
    if vim.lsp.get_clients({ name = "rust-analyzer", bufnr = 0 })[1] then
      return
    end

    -- Root detection: look for Cargo.toml, otherwise fallback to cwd
    local root = vim.fs.find({ "Cargo.toml", ".git" }, { upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()

    vim.lsp.start({
      name = "rust-analyzer",
      cmd = { "rust-analyzer" },
      root_dir = root,
      on_attach = function(client, bufnr)
        -- Optional: enable formatting keybind
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end, { buffer = bufnr, desc = "Format Rust file" })
        end
      end,
    })
  end,
})

-- =========================
-- Autoformat on save for Rust
-- =========================
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

-- =========================
-- Python LSP (pyright)
-- =========================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Prevent multiple LSP clients for the same buffer
    if vim.lsp.get_clients({ name = "pyright", bufnr = 0 })[1] then
      return
    end

    -- Root detection: look for pyproject.toml, setup.py, or .git
    local root = vim.fs.find({ "pyproject.toml", "setup.py", ".git" }, { upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()

    vim.lsp.start({
      name = "pyright",
      cmd = { "pyright-langserver", "--stdio" },
      root_dir = root,
      on_attach = function(client, bufnr)
        -- Optional: enable formatting keybind
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end, { buffer = bufnr, desc = "Format Python file" })
        end
      end,
    })
  end,
})

-- =========================
-- Autoformat on save for Python
-- =========================
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})
