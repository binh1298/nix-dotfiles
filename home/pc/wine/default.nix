{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # support 64-bit only
    (wine.override {wineBuild = "wine64";})

    # support 64-bit only
    wine64

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
}
