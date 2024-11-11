{username, ...}: {
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  imports = [
    ./shared/cli
    ./shared/cli-apps
    ./shared/dev
    ./shared/system
    ./shared/tools/git-token
    ./pc/cli
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      # (import ../../overlays/firefox-overlay.nix)
    ];
  };

  fonts.fontconfig.enable = true;

  # xdg.configFile."nvim/" = {
  #   source = pkgs.callPackage ../packages/nvchad {};
  # };

  home.sessionPath = ["$HOME/.local/bin"];
}
