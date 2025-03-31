{
  pkgs,
  inputs,
  username,
  ...
}: {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  imports = [
    ./shared/apps
    ./shared/cli
    ./shared/cli-apps
    ./shared/desktop
    ./shared/dev
    ./shared/system
    ./shared/tools/git-token
    ./pc/cli
    ./pc/desktop
    ./pc/dev/misc.nix
    ./pc/themes
    ./pc/apps
    ./pc/fcitx5
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      # (import ../../overlays/firefox-overlay.nix)
      # inputs.neovim-nightly-overlay.overlay
    ];
  };

  fonts.fontconfig.enable = true;

   xdg.configFile."nvim/" = {
     source = pkgs.callPackage ../packages/nvchad {};
   };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
