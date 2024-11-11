{
  config,
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/pc.nix
    ];
  };

  # Bootloader.
  boot = {
    kernelModules = ["v4l2loopback"]; # Autostart kernel modules on boot
    extraModulePackages = [pkgs.linuxPackages.v4l2loopback]; # loopback module to make OBS virtual camera work
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
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
        efiInstallAsRemovable = true;
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
    enabled = "fcitx5";
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

  # Allow unfree packages + use overlays
  nixpkgs = {config = {allowUnfree = true;};};

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
      __GL_VRR_ALLOWED = "1"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
      XCURSOR_THEME = "macOS-BigSur";
      XCURSOR_SIZE = "32";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      EDITOR = "nvim";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
      WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
      DEFAULT_BROWSER = "${pkgs.brave}/bin/firefox"; # Set default browser
      # GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      OBSIDIAN_USE_WAYLAND = "1";
    };
    systemPackages = with pkgs; [
      v4l-utils
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

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };

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
      videoDrivers = ["nvidia"];
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

  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
    package = pkgs.nixVersions.stable;
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
  system.stateVersion = "22.11"; # Did you read the comment?
}
