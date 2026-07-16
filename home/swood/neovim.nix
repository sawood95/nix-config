# Adapted from bashbunni/dotfiles' Packer-based nvim config. Plugins and LSP
# servers are pulled from nixpkgs instead of Packer/Mason, so the editor is
# fully usable offline right after the first `nixos-rebuild switch` — no
# :PackerSync or :MasonInstall step needed. Dropped the more niche/personal
# plugins (hop, mind.nvim, dap, neogit, lspsaga); add them back here if you
# miss them.
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      gopls
      nil
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-treesitter.withAllGrammars
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-web-devicons
      lualine-nvim
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
    ];

    initLua = ''
      vim.g.mapleader = " "

      local opt = vim.opt
      opt.number = true
      opt.mouse = "a"
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true
      opt.smartindent = true
      opt.clipboard = "unnamedplus"
      opt.scrolloff = 7
      opt.ignorecase = true
      opt.smartcase = true
      opt.termguicolors = true
      opt.signcolumn = "yes"
      opt.updatetime = 250
      opt.backup = false
      opt.swapfile = false

      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")

      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      require("telescope").setup({
        defaults = { prompt_prefix = "> " },
      })
      pcall(require("telescope").load_extension, "fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, {})
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, {})
      vim.keymap.set("n", "H", "<cmd>bprevious<CR>")
      vim.keymap.set("n", "L", "<cmd>bnext<CR>")

      require("lualine").setup({ options = { theme = "catppuccin" } })
      require("colorizer").setup()

      -- Completion
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- LSP: servers installed via extraPackages above. Add more by
      -- installing the server package and its name here.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr }) end
        map("n", "K", vim.lsp.buf.hover)
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "gi", vim.lsp.buf.implementation)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "<leader>ca", vim.lsp.buf.code_action)
        map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end)
      end

      for _, server in ipairs({ "lua_ls", "gopls", "nil_ls" }) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    '';
  };
}
