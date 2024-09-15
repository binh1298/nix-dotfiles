{pkgs, ...}: {
  home.packages = with pkgs; [
    # teams
    openvpn3
  ];
}
