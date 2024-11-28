{
  inputs,
  config,
  pkgs,
  system,
  ...
}: {
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = true;
    extraLuaPackages = ps: [ps.magick];
  };

  home.packages = with pkgs; [
    typescript-language-server
    vue-language-server
    eslint
    prettierd
    eslint_d
    bash-language-server
    shellcheck
    yaml-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
  ];
}
