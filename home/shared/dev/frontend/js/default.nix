{pkgs, ...}: {
  home.file.".npmrc" = {
    force = true;
    text = ''
      prefix=~/.npm-global
    '';
  };
  home.packages = with pkgs; [
    # NPM packages
    bun
    yarn
    # deno
    nodejs
    # nodejs-18_x
    # node2nix
    # typescript
    tailwindcss
    # nodePackages.npm # Package manager
    nodePackages_latest.pnpm
    biome
    nodePackages."@microsoft/rush"
    electron
    # nodePackages_latest.ts-node
    # nodePackages_latest.prisma
    # nodePackages_latest.dotenv-cli
    # nodePackages_latest.prettier
    # nodePackages_latest.tailwindcss
    # nodePackages_latest.live-server # Live server
  ];
}
