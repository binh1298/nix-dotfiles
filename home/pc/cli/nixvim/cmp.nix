_: {
  programs.nixvim = {
    plugins = {
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
        };
      };
      cmp-buffer = {enable = true;};
      cmp-emoji = {enable = true;};
      cmp-path = {enable = true;};
      cmp_luasnip = {enable = true;};
      cmp-cmdline.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet = {expand = "luasnip";};

          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            # {name = "luasnip";}
            # {name = "cmdline";}
            # {name = "nvim_lua";}
            {name = "vim-dadbod-completion";}
          ];

          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          };
        };
      };
    };
  };
}
