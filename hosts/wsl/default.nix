{
  pkgs,
  username,
  inputs,
  ...
}: {
  system.stateVersion = "22.05";

  time.timeZone = "Asia/Ho_Chi_Minh";

  networking.hostName = "nixos";

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];
  environment.enableAllTerminfo = true;
  environment = {
    systemPackages = [pkgs.coreutils];
  };

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = username;
    initialPassword = "123123";
    extraGroups = ["networkmanager" "wheel" "input" "docker" "libvirtd"];
    
    # home = "/home/${username}";
  };
  home-manager.users.${username} = {
    imports = [
      ../../home/wsl.nix
    ];
  };

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [username];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
