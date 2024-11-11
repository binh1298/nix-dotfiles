{pkgs, ...}: {
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    dejavu_fonts
    font-awesome
    fira-code-symbols
    powerline-symbols
    material-design-icons
    commit-mono
    (nerdfonts.override {fonts = ["IBMPlexMono" "CascadiaCode" "FiraCode" "FiraMono" "JetBrainsMono" "Ubuntu"];})
  ];
}
