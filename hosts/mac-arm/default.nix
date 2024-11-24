{
  pkgs,
  username,
  ...
}: {
  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [bash zsh];
    # loginShell = pkgs.zsh;
    systemPackages = [pkgs.coreutils pkgs.readline];
    systemPath = ["opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # fonts.fontDir.enable = true;
  # fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  services.nix-daemon.enable = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock.autohide = false;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
  };
  users.users.${username}.home = "/Users/${username}";
  home-manager.users.${username} = {
    imports = [
      ../../home/mac.nix
    ];
  };

  # backwards compat; don't change
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = ["raycast" "amethyst" "font-hack-nerd-font" "font-sf-pro" "font-sf-mono" "sf-symbols" "steam" "kitty"];
    taps = ["fujiapple852/trippy" "FelixKratz/formulae"];
    brews = ["trippy" "sketchybar" "borders" "jq" "gh" "switchaudio-osx" "nowplaying-cli"];
    onActivation.cleanup = "zap";
  };
}
