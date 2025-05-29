{secrets, ...}: {
  home.file.".gitignore" = {
    force = true;
    text = ''
      server exited unexpectedly
      .DS_Store
    '';
  };
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Pham Duc Binh";
        email = "binh1298@gmail.com";
      };
      url."https://${secrets.github_token}:x-oauth-basic@github.com/".insteadOf = "git@github.com:";
      url."https://".insteadOf = "git://";
      url."https://${secrets.github_token}:x-oauth-basic@github.com/manabie-com".insteadOf = "https://github.com/manabie-com";

      url."https://${secrets.gitlab_ah_user}:${secrets.gitlab_ah_token}@code.vng.vn".insteadOf = "https://code.vng.vn";

      url."https://${secrets.gitlab_vga_user}:${secrets.gitlab_vga_token}@gitlab.gt.vng.vn".insteadOf = "https://gitlab.gt.vng.vn";

      core.editor = "nvim";
      core.excludesfile = "~/.gitignore";
      pull.rebase = false;
    };
    lfs.enable = true;
  };
}
