{pkgs, ...}: {
  # home.packages = with pkgs; [];

  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 2500;
          lsp_fallback = true;
        };
        formatters = {
          "biome-check" = {
            require_cwd = true;
          };
        };
        formatters_by_ft = {
          lua = ["stylua"];
          # Conform will run multiple formatters sequentially
          python = ["isort" "black"];
          # Use a sub-list to run only the first available formatter
          javascript = [["biome-check" "prettier"]];
          typescript = [["biome-check" "prettierd"]];
          tsx = ["biome-check" "prettier" "rustywind"];
          jsx = ["biome-check" "prettier" "rustywind"];
          typescriptreact = ["biome-check" "prettierd" "rustywind"];
          javascriptreact = ["biome-check" "prettierd" "rustywind"];
          nix = [["alejandra"]];
          go = ["gofmt" "gofumt" "goimports_reviser" "golines"];
          rust = [["rustfmt"]];
          # yaml = [["prettier"]];
          json = [["biome-check" "prettier"]];
          sql = [["sqlfmt"]];
          html = [["biome-check" "prettier"]];
          css = [["biome-check" "prettier"]];
          markdown = [["prettier"]];
          graphql = [["biome-check" "prettier"]];

          # Use the "*" filetype to run formatters on all filetypes.
          # "*" = ["codespell"];
          # Use the "_" filetype to run formatters on filetypes that don't
          # have other formatters configured.
          "_" = ["trim_whitespace"];
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>fm";
        options.silent = true;
        options.desc = "format files";
        action =
          #lua
          ''
            function()
              require("conform").format({ lsp_fallback = true })
            end
          '';
      }
      {
        mode = "n";
        key = "<leader>ca";
        action =
          # lua
          "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code action";
      }
    ];
  };
}
