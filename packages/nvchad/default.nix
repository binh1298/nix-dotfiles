{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}: let
  custom = ./custom;
in
  stdenvNoCC.mkDerivation rec {
    name = "nvchad";
    version = "2.5";

    src = fetchFromGitHub {
      owner = "binh1298";
      repo = "starter";
      rev = "main";
      sha256 = "umkU1S8Tgz+mexxxpB1JyosTWRCnWOd0cRlXz+3yFeA=";
    };

    preferLocalBuild = true;

    # remember to rm -rf .config/nvim .local/share/nvim .cache/nvim when reinstalling on mac
    # rm -rf ~/.config/nvim
    # rm -rf ~/.local/share/nvim
    # rm -rf ~/.cache/nvim
    installPhase = ''
      mkdir -p $out
      cp -r ./ $out
    '';

    meta = with lib; {
      description = "NvChad";
      homepage = "https://github.com/NvChad/starter";
      platforms = platforms.all;
      license = licenses.gpl3;
    };
  }
