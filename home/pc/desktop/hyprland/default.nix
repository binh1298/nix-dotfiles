{
  inputs,
  pkgs,
  ...
}: let
  hyprland_flake = inputs.hyprland.packages.${pkgs.system}.hyprland;
  fontsize = "12";
  oxocarbon_pink = "ff7eb6";
  oxocarbon_border = "393939";
  oxocarbon_background = "161616";
  background = "rgba(11111B00)";
  tokyonight_border = "rgba(7aa2f7ee) rgba(87aaf8ee) 45deg";
  tokyonight_background = "rgba(32344aaa)";
  catppuccin_border = "rgba(b4befeee)";
  opacity = ".95";
  cursor = "macOS-BigSur";
in {
  home.packages = with pkgs; [
    grim
    slurp
    swappy

    (writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" - | wl-copy && wl-paste | swappy -f -
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland = {enable = true;};
    settings = {
      "$mainMod" = "ALT";
      monitor = [
        # "eDP-1,1920x1080,0x0,1"
        # ",1920x1080,auto,1"
        "DP-2,2560x1440@144,0x0,1"
        "HDMI-A-1,1920x1080@60,2560x0,1"
        "Unknown-1,disable"
      ];

      xwayland = {force_zero_scaling = true;};

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        repeat_delay = 300;
        repeat_rate = 70;
        numlock_by_default = 1;
        accel_profile = "flat";
        sensitivity = 0;
        force_no_accel = 1;
        touchpad = {natural_scroll = 1;};
      };

      general = {
        gaps_in = 1;
        gaps_out = 2;
        border_size = 3;
        "col.active_border" = "${catppuccin_border}";
        "col.inactive_border" = "${tokyonight_background}";
        layout = "dwindle";
        apply_sens_to_raw =
          1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };

      decoration = {
        rounding = 12;
        shadow_ignore_window = true;
        drop_shadow = false;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgb(${oxocarbon_background})";
        "col.shadow_inactive" = "${background}";
        blur = {
          enabled = false;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 1.17e-2;
          contrast = 1.5;
          brightness = 1;
          xray = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "pace,0.46, 1, 0.29, 0.99"
          "overshot,0.13,0.99,0.29,1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "windowsIn,1,1,md3_decel,slide"
          "windowsOut,1,1,md3_decel,slide"
          "windowsMove,1,3,md3_decel,slide"
          "fade,1,5,md3_decel"
          "workspaces,1,4,md3_decel,slide"
          "workspaces, 1, 3, default"
          "specialWorkspace,1,4,md3_decel,slide"
          "border,1,5,md3_decel"
        ];
      };

      misc = {
        vfr =
          true; # misc:no_vfr -> misc:vfr. bool, heavily recommended to leave at default on. Saves on CPU usage.
        vrr =
          true; # misc:vrr -> Adaptive sync of your monitor. 0 (off), 1 (on), 2 (fullscreen only). Default 0 to avoid white flashes on select hardware.
      };

      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        force_split = 0;
        preserve_split = true;
        default_split_ratio = 1.0;
        no_gaps_when_only = false;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
      };

      master = {
        mfact = 0.5;
        orientation = "right";
        special_scale_factor = 0.8;
        new_is_master = true;
        no_gaps_when_only = false;
      };

      gestures = {workspace_swipe = false;};

      debug = {
        damage_tracking =
          2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
      };

      exec-once = [
        "easyeffects --gapplication-service" # Starts easyeffects in the background
        "$HOME/.config/hypr/autostart"
        "exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      bind = [
        "$mainMod,Q,killactive,"
        "$mainMod,M,exit,"
        "$mainMod,W,togglefloating,"
        "$mainMod,g,togglegroup"
        # "$mainMod,tab,changegroupactive"
        # "$mainMod,P,pseudo,"

        # Vim binds
        "$mainMod,h,movefocus,l"
        "$mainMod,l,movefocus,r"
        "$mainMod,k,movefocus,u"
        "$mainMod,j,movefocus,d"

        "$mainMod,left,movefocus,l"
        "$mainMod,down,movefocus,r"
        "$mainMod,up,movefocus,u"
        "$mainMod,right,movefocus,d"

        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"
        "$mainMod,4,workspace,4"
        "$mainMod,5,workspace,5"
        "$mainMod,6,workspace,6"
        "$mainMod,7,workspace,7"
        "$mainMod,8,workspace,8"
        # "$mainMod,9,workspace,9"
        # "$mainMod,0,workspace,10"

        #CTRL,1,workspace,1
        #CTRL,2,workspace,2
        #CTRL,3,workspace,3
        #CTRL,4,workspace,4
        #CTRL,5,workspace,5
        #CTRL,6,workspace,6

        ################################## Move ###########################################
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        #---------------------------------------------------------------#
        # Move active window to a workspace with mainMod + ctrl + [0-9] #
        #---------------------------------------------------------------#
        # "$mainMod CTRL, 1, movetoworkspace, 1"
        # "$mainMod CTRL, 2, movetoworkspace, 2"
        # "$mainMod CTRL, 3, movetoworkspace, 3"
        # "$mainMod CTRL, 4, movetoworkspace, 4"
        # "$mainMod CTRL, 5, movetoworkspace, 5"
        # "$mainMod CTRL, 6, movetoworkspace, 6"
        # "$mainMod CTRL, 7, movetoworkspace, 7"
        # "$mainMod CTRL, 8, movetoworkspace, 8"
        # "$mainMod CTRL, 9, movetoworkspace, 9"
        # "$mainMod CTRL, 0, movetoworkspace, 10"
        # "$mainMod CTRL, left, movetoworkspace, -1"
        # "$mainMod CTRL, right, movetoworkspace, +1"
        # same as above, but doesnt switch to the workspace
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        # "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        # "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        "$mainMod,T,exec,kitty"
        "$mainMod SHIFT,S,exec,screenshot"
        "$mainMod SHIFT,C,exec,wallpaper"
        "$mainMod,A,exec,fuzzel"
        "$mainMod,F,fullscreen"
        # "$mainMod,z,exec,waybar"
        # "$mainMod,space,exec, tofi-drun --drun-launch=true"
        # $mainMod,space,exec,wofi --show drun -I -s ~/.config/wofi/style.css DP-3
        # "$mainMod SHIFT,V,exec,~/.config/eww/fool_moon/bar/scripts/widgets toggle-clip"
        # "$mainMod SHIFT,C,exec,~/.config/hypr/scripts/wallpaper_picker"
        # "$mainMod,space,exec, tofi-drun --drun-launch=true"
        # $mainMod,space,exec,wofi --show drun -I -s ~/.config/wofi/style.css DP-3
        # "$mainMod SHIFT,V,exec,~/.config/eww/fool_moon/bar/scripts/widgets toggle-clip"
        # "$mainMod SHIFT,C,exec,~/.config/hypr/scripts/wallpaper_picker"
        # "$mainMod SHIFT,B,exec, killall -3 eww & sleep 1 && ~/.config/hypr/themes/winter/eww/launch_bar"
      ];

      bindm = [
        # Mouse binds
        "$mainMod,mouse:272,movewindow"
        "$mainMod,mouse:273,resizewindow"
      ];

      bindle = [
        # Backlight Keys
        ",XF86MonBrightnessUp,exec,brightnessctl set 5+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        # Volume Keys
        ",XF86AudioRaiseVolume,exec,amixer -D pipewire sset Master 5%+"
        ",XF86AudioLowerVolume,exec,amixer -D pipewire sset Master 5%-"
      ];
      bindl = [
        ",switch:on:Lid Switch, exec, swaylock -i ~/Pictures/programmer.gif"

        ",switch:off:Lid Switch, exec, swaylock -i ~/Pictures/programmer.gif"
      ];

      windowrule = [
        # Window rules
        "tile,title:^(kitty)$"
        "float,title:^(fly_is_kitty)$"
        "tile,^(Spotify)$"
        # "tile,^(neovide)$"
        "tile,^(wps)$"
      ];

      windowrulev2 = [
        "opacity ${opacity} ${opacity},class:^(thunar)$"
        # "opacity ${custom.opacity} ${custom.opacity},class:^(WebCord)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,title:^(mpv)$"
        "opacity 1.0 1.0,class:^(wofi)$"
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
      ];
    };

    # Submaps
    extraConfig = ''
           # source = ~/.config/hypr/themes/catppuccin-macchiato.conf
           # source = ~/.config/hypr/themes/oxocarbon.conf
           env = XDG_SESSION_TYPE,wayland

           env = LIBVA_DRIVER_NAME,nvidia
           env = GBM_BACKEND,nvidia-drm
           env = __GLX_VENDOR_LIBRARY_NAME,nvidia
           env = WLR_NO_HARDWARE_CURSORS,1
      #     # will switch to a submap called resize
      #     bind=$mainMod,R,submap,resize
      #
      #     # will start a submap called "resize"
      #     submap=resize
      #
      #     # sets repeatable binds for resizing the active window
      #     binde=,L,resizeactive,15 0
      #     binde=,H,resizeactive,-15 0
      #     binde=,K,resizeactive,0 -15
      #     binde=,J,resizeactive,0 15
      #
      #     # use reset to go back to the global submap
      #     bind=,escape,submap,reset
      #     bind=$mainMod,R,submap,reset
      #
      #     # will reset the submap, meaning end the current one and return to the global one
      #     submap=reset
    '';
  };
  # Hyprland configuration files
  xdg.configFile = {
    "hypr/autostart".source = ./autostart;
    "hypr/store/dynamic_out.txt".source = ./store/dynamic_out.txt;
    "hypr/store/prev.txt".source = ./store/prev.txt;
    "hypr/store/latest_notif".source = ./store/latest_notif;
    "hypr/scripts/wall".source = ./scripts/wall;
    "hypr/scripts/launch_waybar".source = ./scripts/launch_waybar;
    "hypr/scripts/tools/dynamic".source = ./scripts/tools/dynamic;
    "hypr/scripts/tools/expand".source = ./scripts/tools/expand;
    "hypr/scripts/tools/notif".source = ./scripts/tools/notif;
    "hypr/scripts/tools/start_dyn".source = ./scripts/tools/start_dyn;
    "hypr/scripts/tools/swww".source = ./scripts/tools/swww;
  };
}
