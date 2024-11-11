_: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          ts_ls = {
            enable = true;
            extraOptions = {
              preferences = {
                importModuleSpecifierPreference = "non-relative";
                import_module_specifier_preference = "non-relative";
              };
              server_capabilities = {documentFormattingProvider = false;};
            };
            settings = {
              preferences = {
                importModuleSpecifierPreference = "non-relative";
                import_module_specifier_preference = "non-relative";
              };
              server_capabilities = {documentFormattingProvider = false;};
            };
          };
          gopls = {
            enable = true;
            cmd = ["gopls"];
            filetypes = ["go" "gomod" "gowork" "gotmpl"];
            rootDir =
              #lua
              ''require("lspconfig").util.root_pattern("go.work", "go.mod", ".git")'';
            settings = {
              gopls = {
                completeUnimported = true;
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
              };
            };
          };
          lua_ls.enable = true;
          biome.enable = true;
          tailwindcss.enable = true;
          eslint.enable = true;
          astro.enable = true;
          html.enable = true;
          cssls.enable = true;
          bashls.enable = true;
          yamlls.enable = true;
          nil_ls.enable = true;
          #TODO: Apex, cucumber
        };
      };
    };
  };
}
