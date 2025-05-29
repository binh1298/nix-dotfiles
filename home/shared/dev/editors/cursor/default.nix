{
  pkgs,
  secrets,
  ...
}: {
  home.file.".config/Cursor/User/keybindings.json" = {
    force = true;
    text = ''
      [
        {
          "key": "a",
          "command": "explorer.newFile",
          "when": "explorerViewletFocus && !inputFocus"
        },
          {
            "key": "ctrl+shift+alt+h",
            "command": "workbench.files.action.focusFilesExplorer"
          }
      ]
    '';
  };
  home.packages = with pkgs; [
    code-cursor
  ];
}
