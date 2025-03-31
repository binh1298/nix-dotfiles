{pkgs, ...}: {
  home.file.".vscode/argv.json" = {
    force = true;
    text = ''
      {
      	// "disable-hardware-acceleration": true,
      	"enable-crash-reporter": false,
      	// Unique id used for correlating crash reports sent from this instance.
      	// Do not edit this value.
        "crash-reporter-id": "YOUR_CRASH_ID_HERE",
         "password-store": "gnome"
      }
    '';
  };
  home.file.".config/Code/User/keybindings.json" = {
    force = true;
    text = ''
      [
        {
          "key": "a",
          "command": "explorer.newFile",
          "when": "explorerViewletFocus && !inputFocus"
        }
      ]
    '';
  };

  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;
    # package = pkgs.vscode.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions;
      [
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        eamodio.gitlens
        github.copilot
        github.copilot-chat
        redhat.vscode-yaml
        redhat.vscode-xml
        timonwong.shellcheck
        ms-kubernetes-tools.vscode-kubernetes-tools
        vscodevim.vim
        bradlc.vscode-tailwindcss
        mechatroner.rainbow-csv
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "salesforcedx-vscode";
          publisher = "salesforce";
          version = "59.13.0";
          sha256 = "sha256-YWrNFDXUT4VPiIJYP4qN7OGaQL58k4s/9JSlz0dYwZ4=";
        }
        {
          name = "makefile-tools";
          publisher = "ms-vscode";
          version = "0.9.2";
          sha256 = "sha256-6mlm7oSiixuRc/tq0EvIkOfVkoaZem6PqwV95+BQnVU=";
        }
        {
          name = "Go";
          publisher = "golang";
          version = "0.40.1";
          sha256 = "sha256-KeYui/REV9E1HcNWBb0ThD0fOWkMM0AVTyfiE1efhCA=";
        }
        {
          name = "vscode-jest-runner";
          publisher = "firsttris";
          version = "0.4.72";
          sha256 = "sha256-1nUpOXdteWsyFYJ2uATCcr1SUbeusmbpa09Bkw9/TZM=";
        }
        {
          name = "biome";
          publisher = "biomejs";
          version = "2.1.2";
          sha256 = "sha256-bPAig5KK6hYxyAyt48Mfi2dEf50/hNiNngX7bTzIKcQ=";
        }
        {
          name = "mongodb-vscode";
          publisher = "mongodb";
          version = "1.6.0";
          sha256 = "sha256-XZykYkIwu4rx9guYpIOPU4OPUpi437u98KP+YfbSMBs=";
        }
      ];
    profiles.default.userSettings = {
      # "[typescriptreact]" = {
      #   "editor.defaultFormatter" = "biomejs.biome";
      # };
      # "[javascript]" = {
      #   "editor.defaultFormatter" = "biomejs.biome";
      # };
      # "[json]" = {
      #   "editor.defaultFormatter" = "biomejs.biome";
      # };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[css]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[xml]" = {
        "editor.defaultFormatter" = "redhat.vscode-xml";
      };
      "window.titleBarStyle" = "custom";
      "editor.fontSize" = 12;
      "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
      "extensions.autoUpdate" = true;
      "workbench.statusBar.visible" = true;
      "terminal.external.linuxExec" = "kitty";
      "telemetry.telemetryLevel" = "off";
      "editor.lineNumbers" = "relative";
      "vim.useSystemClipboard" = true;
      "terminal.integrated.shell.linux" = "zsh";
      "editor.formatOnSave" = true;
      "terminal.integrated.scrollback" = 100000;
    };
  };
}
