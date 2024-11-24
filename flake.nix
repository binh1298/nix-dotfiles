{
  description = "binh1298's NixOS config for desktop and WSL";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    waybar-hyprland.url = "github:Alexays/Waybar";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs:
    with inputs; let
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

      homeManagerDefaults = specialArgs: {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = specialArgs;
      };

      macUserName = "lap16096";
      pcUserName = "binh1298";
      wslUserName = "BinhWSL";
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
      darwinPackages = self.darwinConfigurations."HX-VT-WS-A029".pkgs;
      darwinConfigurations = let
        username = macUserName;
        specialArgs = {inherit inputs username secrets;};
      in {
        binh-mbp = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = specialArgs;
          pkgs = import nixpkgs {system = "aarch64-darwin";};
          modules = [
            ./hosts/mac-arm
            home-manager.darwinModules.home-manager
            (homeManagerDefaults specialArgs)
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = macUserName;
              };
            }
          ];
        };
      };
      nixosConfigurations = {
        binh-pc = let
          username = pcUserName;
          specialArgs = {inherit inputs username secrets;};
        in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = [
              ./hosts/binh1298/configuration.nix
              home-manager.nixosModules.home-manager
              (homeManagerDefaults specialArgs)
              hyprland.nixosModules.default
              {programs.hyprland.enable = true;}
            ];
          };
        binh-wsl = let
          username = wslUserName;
          specialArgs = {inherit inputs username secrets;};
        in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = [
              NixOS-WSL.nixosModules.wsl
              ./hosts/wsl/default.nix
              home-manager.nixosModules.home-manager
              (homeManagerDefaults specialArgs)
            ];
          };
      };
    };
}
