{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./cmp.nix
    ./conform.nix
    ./lsp.nix
    ./nvim-tree.nix
    # ./neo-tree.nix
    # ./chadtree.nix
    ./rust.nix
    ./telescope.nix
    ./treesitter.nix
    ./which-key.nix
    ./barbar.nix
  ];
  home.packages = with pkgs; [prettierd eslint_d shellcheck rustywind];
  #TODO: CSV, tailwind colorizer
  programs.nixvim = {
    enable = true;
    plugins = {
      avante.enable = true;
      web-devicons.enable = true;
      image.enable = true;
      markdown-preview.enable = true;
      copilot-lua = {
        enable = true;
        suggestion = {
          enabled = true;
          autoTrigger = true;
          keymap = {
            accept = "<C-A>";
          };
        };
      };
      indent-blankline.enable = true;
      nvim-colorizer = {
        enable = true;
        userDefaultOptions.tailwind = true;
      };
      comment.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
        };
      };
      telescope.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
      lualine.enable = true;
      tmux-navigator.enable = true;
      nvim-autopairs.enable = true;
      # auto-session.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      base46
      nvchad
      nvchad-ui
      plenary-nvim
      nvim-web-devicons
      vim-dadbod-ui
      vim-dadbod-completion
      vim-dadbod
    ];

    extraConfigLua =
      #Lua
      ''
        -- CONFORM
        require("conform").setup({
          format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 2500, lsp_format = "fallback" }
          end,
        })

        vim.api.nvim_create_user_command("ConformDisable", function(args)
          if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat-on-save",
          bang = true,
        })
        vim.api.nvim_create_user_command("ConformEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
          desc = "Re-enable autoformat-on-save",
        })

        -- RENAMER
        local map = vim.keymap.set

        local function apply(curr, win)
          local newName = vim.trim(vim.fn.getline ".")
          vim.api.nvim_win_close(win, true)

          if #newName > 0 and newName ~= curr then
            local params = vim.lsp.util.make_position_params()
            params.newName = newName

            vim.lsp.buf_request(0, "textDocument/rename", params)
          end
        end

        map("n", "<leader>ra", function()
          local currName = vim.fn.expand "<cword>" .. " "

          local win = require("plenary.popup").create(currName, {
            title = "Renamer",
            style = "minimal",
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            relative = "cursor",
            borderhighlight = "RenamerBorder",
            titlehighlight = "RenamerTitle",
            focusable = true,
            width = 25,
            height = 1,
            line = "cursor+2",
            col = "cursor-1",
          })

          vim.cmd "normal A"
          vim.cmd "startinsert"

          map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

          map({ "i", "n" }, "<CR>", function()
            apply(currName, win)
            vim.cmd.stopinsert()
          end, { buffer = 0 })
        end, {desc = "rename variable"})
      '';

    opts = {
      laststatus = 3;
      showmode = false;
      clipboard = "unnamedplus";
      cursorline = true;
      cursorlineopt = "number";
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      softtabstop = 2;
      fillchars = {eob = " ";};
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      number = true;
      relativenumber = true;
      numberwidth = 2;
      ruler = false;
      shortmess = "sI";
      signcolumn = "yes";
      splitbelow = true;
      splitright = true;
      timeoutlen = 400;
      undofile = true;
      updatetime = 250;
      whichwrap = "<>[]hl";
    };

    globals.mapleader = " ";
    globals.togglethemeicon = "   ";

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        disable_underline = true;
        flavour = "mocha";
        integrations = {
          cmp = true;
          gitsigns = true;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
          notify = false;
          nvimtree = true;
          treesitter = true;
        };
        styles = {
          booleans = ["bold" "italic"];
          conditionals = ["bold"];
        };
        term_colors = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<C-h>";
        options.silent = true;
        options.desc = "switch window left";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-l>";
        options.silent = true;
        options.desc = "switch window right";
        action = "<C-w>l";
      }
      {
        mode = "n";
        key = "<C-j>";
        options.silent = true;
        options.desc = "switch window down";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        options.silent = true;
        options.desc = "switch window up";
        action = "<C-w>k";
      }
      {
        mode = "i";
        key = "<C-s>";
        options.silent = true;
        options.desc = "Save file & Exit Input Mode";
        action = "<Esc> <C-s> <cmd> w <CR>";
      }
      {
        mode = "n";
        key = "<C-s>";
        options.silent = true;
        options.desc = "file save";
        action = "<cmd>w<CR>";
      }
      {
        mode = "n";
        key = "<leader>h";
        options.silent = true;
        options.desc = "hover";
        action = "<cmd> lua vim.lsp.buf.hover()<CR>";
      }
      {
        mode = "n";
        key = "<leader>fl";
        options.silent = true;
        options.desc = "Floating diagnostics";
        action = ''
          <cmd>lua vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
        '';
      }
    ];
  };
}
