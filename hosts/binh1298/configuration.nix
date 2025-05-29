{
  config,
  pkgs,
  inputs,
  username,
  lib,
  secrets,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../home/pc/wine
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/pc.nix
    ];
  };

  programs.openvpn3.enable = true;
  services.openvpn.servers = {
    office = {
      config = ''config /home/${username}/Downloads/lpsvpn_client_3 6.ovpn'';
      autoStart = false; # Set to true if you want it to start automatically
      authUserPass = {
        username = "${secrets.vpn_username}";
        password = "${secrets.vpn_corp_token}";
      };
      updateResolvConf = true; # For DNS resolution
    };
    gitlab = {
      config = ''config /home/${username}/Downloads/profile-9799.ovpn'';
      autoStart = false; # Set to true if you want it to start automatically
      authUserPass = {
        username = "${secrets.vpn_username}";
        password = "${secrets.vpn_gl_token}";
      };
      updateResolvConf = true; # For DNS resolution
    };
  };


  fileSystems = {
    "/home/${username}/data" = {
      device = "/dev/disk/by-uuid/ACD4D5B4D4D5814E";
      fsType = "ntfs";
      options = ["users" "nofail"];
    };
    "/home/${username}/windows" = {
      device = "/dev/disk/by-uuid/D0765DB4765D9BD2";
      fsType = "ntfs";
      options = ["users" "nofail"];
    };
  };
  # Bootloader.
  boot = {
    kernelModules = ["r8125" "r8169" "iwlwifi"]; # Autostart kernel modules on boot
    # extraModulePackages = [pkgs.linuxPackages.v4l2loopback]; # loopback module to make OBS virtual camera work
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot.enable = false; # (for UEFI systems only)
      timeout = 3;
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        # Change this to true when you have multiple OSes installed
        efiInstallAsRemovable = false;
        configurationLimit = 3;
        theme = pkgs.fetchFromGitHub {
          owner = "Lxtharia";
          repo = "minegrub-theme";
          rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
          sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
        };
      };
    };
  };

  # Change systemd stop job timeout in NixOS configuration (Default = 90s)
  systemd = {
    services.NetworkManager-wait-online.enable = false;
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    # no need to wait interfaces to have an IP to continue booting
    dhcpcd.wait = "background";
    # avoid checking if IP is already taken to boot a few seconds faster
    dhcpcd.extraConfig = "noarp";
    hostName = "nixos"; # Define your hostname.
    interfaces.enp7s0.useDHCP = true;
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      gtk4
      fcitx5-gtk
      fcitx5-unikey
      fcitx5-chinese-addons
      fcitx5-anthy
      fcitx5-nord
      libsForQt5.fcitx5-qt
    ];
  };

  # Enable programs
  programs = {
    zsh.enable = true;
    steam.enable = true;
    dconf.enable = true;
    hyprland = {
      enable = true;
      xwayland = {enable = true;};
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "steam"
      "steam-unwrapped"

      "cuda_cudart"
      "libcublas"
      "cuda_cccl"
      "cuda_nvcc"

      "lmstudio"
      "ngrok"
    ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Times, Noto Serif"];
        sansSerif = ["Helvetica Neue LT Std, Helvetica, Noto Sans"];
        monospace = ["Courier Prime, Courier, Noto Sans Mono"];
      };
    };
  };

  # Enables docker in rootless mode
  virtualisation = {
    docker = {
      enable = true;
    };
    # Enables virtualization for virt-manager
    libvirtd.enable = true;
  };

  environment = {
    variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      XCURSOR_THEME = "macOS-BigSur";
      XCURSOR_SIZE = "32";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      EDITOR = "nvim";
    };
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      WLR_DRM_NO_ATOMIC = "1";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";

      GDK_SCALE = "2";

      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      NVD_BACKEND = "direct";

      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
      WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
      DEFAULT_BROWSER = "${pkgs.brave}/bin/firefox"; # Set default browser
      # GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      OBSIDIAN_USE_WAYLAND = "1";
    };
    systemPackages = with pkgs; [
      lmstudio
      ngrok
      pamixer
      v4l-utils
      pciutils
      killall
      git
      wget
      playerctl
      libsecret
      brightnessctl
      inputs.xdg-portal-hyprland.packages.${system}.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      alejandra
    ];
  };

  # For obsidian
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  # For NVIDIA
  hardware.graphics = {
    enable = true;
  };
  services.ollama.enable = true;
  services.ollama.acceleration = "cuda";
  # services.open-webui.enable = true;
  # services.open-webui.port = 7777;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.133.07";
      sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
      sha256_aarch64 = "";
      openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
      persistencedSha256 = "";
    };
  };
  # End for NVIDIA

  services = {
    xserver = {
      enable = true;
      displayManager = {gdm.enable = true;};
      desktopManager = {xfce.enable = true;};
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      xkb.layout = "us";
      xkb.variant = "";
    };
    libinput = {
      enable = true;
      mouse = {accelProfile = "flat";};
      touchpad = {accelProfile = "flat";};
    };

    logmein-hamachi.enable = false;
    flatpak.enable = false;
    gnome.gnome-keyring.enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  console.keyMap = "us";

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  users = {
    users = {
      ${username} = {
        isNormalUser = true;
        description = username;
        initialPassword = "123123";
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "input" "docker" "libvirtd"];
      };
    };
  };

  security = {
    sudo.enable = true;
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          users = [username];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    pam.services.login.enableGnomeKeyring = true;
    rtkit.enable = true;
    polkit.enable = true; # For obs virtual cam
  };

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  system.stateVersion = "24.11";
}
