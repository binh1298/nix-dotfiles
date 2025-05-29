{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    peek # Animated GIF screen recorder
    traceroute # Tool to access the X clipboard from a console application
    xfce.thunar # Best GUI file manager
    swaylock
    wl-clipboard # Enables copy/paste on wayland
    # Office + PDF readers
    # wpsoffice # MS office alternative for linux
    zathura # PDF viewer
    swww # Cool wallpapers/gifs transitions
    dunst # Notifications for your system
    fuzzel # Dmenu for wayland
    swaylock
    # Audio/Music
    easyeffects
    pavucontrol

    polkit
    polkit_gnome

    appimage-run # Run appimage files in the terminal
    networkmanager
    droidcam

    dbeaver-bin

    # inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
  ];
}
