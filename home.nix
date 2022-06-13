{
  config,
  pkgs,
  lib,
  ...
}: let
  defaultFont = "TerminusTTF Nerd Font Mono";

  ac = "#1E88E5";
  mf = "#383838";

  bg = "#111111";
  fg = "#FFFFFF";

  # Colored
  primary = "#91ddff";

  # Dark
  secondary = "#141228";

  # Colored (light)
  tertiary = "#65b2ff";

  # white
  quaternary = "#ecf0f1";

  # middle gray
  quinternary = "#20203d";

  # Red
  urgency = "#e74c3c";
in {
  fonts.fontconfig.enable = true;

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = with pkgs; [
      nix-direnv
      flameshot
      ranger
      ripgrep
      scrot
      ssh-copy-id
      terminus-nerdfont
      tmux
      tree
      unrar
      unzip
      xbindkeys
      xclip
      xdotool
      xorg.xmodmap
      yq
      zathura
      zip
    ];
  };

  /*
   xsession.windowManager.i3 = let
     modifier = "Mod4";
   in {
     enable = true;
     package = pkgs.i3-gaps;
     config = {
       inherit modifier;
       assigns."1: web" = [{class = "^Firefox$";}];
       assigns."0: extra" = [
         {
           class = "^Firefox$";
           window_role = "About";
         }
       ];
       gaps.inner = 5;
       window.border = 4;
       gaps.smartBorders = "no_gaps";
       gaps.smartGaps = false;
       workspaceAutoBackAndForth = true;
       workspaceLayout = "default";
       gaps.outer = 5;
       fonts.names = [defaultFont];
       fonts.style = "Bold Semi-Condensed";
       fonts.size = 14.0;
       floating.titlebar = false;
       terminal = "alacritty";
       bars = lib.mkForce [];
   
       colors = rec {
         background = bg;
         placeholder = {
           background = "#0c0c0c";
           border = "#000000";
           childBorder = "#0c0c0c";
           indicator = "#000000";
           text = "#ffffff";
         };
   
         focused.background = primary;
         focused.border = primary;
         focused.childBorder = primary;
         focused.indicator = primary;
         focused.text = fg;
   
         focusedInactive.background = quinternary;
         focusedInactive.border = quinternary;
         focusedInactive.childBorder = quinternary;
         focusedInactive.indicator = quinternary;
         focusedInactive.text = fg;
   
         unfocused.background = bg;
         unfocused.border = bg;
         unfocused.childBorder = bg;
         unfocused.indicator = bg;
         unfocused.text = fg;
   
         urgent.background = urgency;
         urgent.border = urgency;
         urgent.childBorder = urgency;
         urgent.indicator = urgency;
         urgent.text = fg;
       };
   
       modes = {
         desktop = {
           "r" = "i3-msg reload";
           "Shift+r" = "i3-msg restart";
           "Shift+q" = "i3-msg exit";
           "Escape" = "mode default";
           "Return" = "mode default";
         };
         move-container = {
           "0" = "move scratchpad; mode default;";
           "1" = "move container to workspace number 1; mode default;";
           "2" = "move container to workspace number 2; mode default;";
           "3" = "move container to workspace number 3; mode default;";
           "4" = "move container to workspace number 4; mode default;";
           "5" = "move container to workspace number 5; mode default;";
           "6" = "move container to workspace number 6; mode default;";
           "7" = "move container to workspace number 7; mode default;";
           "8" = "move container to workspace number 8; mode default;";
           "9" = "move container to workspace number 9; mode default;";
           "Escape" = "mode default";
           "Return" = "mode default";
         };
         resize = {
           "Left" = "resize shrink width 10 px or 10 ppt";
           "Down" = "resize grow height 10 px or 10 ppt";
           "Up" = "resize shrink height 10 px or 10 ppt";
           "Right" = "resize grow width 10 px or 10 ppt";
           "Escape" = "mode default";
           "Return" = "mode default";
         };
       };
   
       startup = [
         {
           command = "exec i3-msg workspace 1";
           always = true;
           notification = false;
         }
         {
           command = "systemctl --user restart polybar.service";
           always = true;
           notification = false;
         }
         # {
         # command = "${pkgs.feh}/bin/feh --bg-scale ~/background.png";
         # always = true;
         # notification = false;
         # }
       ];
   
       keybindings = with pkgs; {
         "XF86Display" = "exec ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --auto --output DP-1 --off --output DP-2 --off --output HDMI-1 --off";
         "${modifier}+XF86Display" = "exec ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --off --output DP-1 --auto --output DP-2 --auto --output HDMI-1 --auto";
         "XF86AudioMute" = "exec amixer set Master toggle";
         "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
         "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
         "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
         "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
   
         "${modifier}+Shift+0" = "move scratchpad";
         "${modifier}+Shift+1" = "move container to workspace number 1";
         "${modifier}+Shift+2" = "move container to workspace number 2";
         "${modifier}+Shift+3" = "move container to workspace number 3";
         "${modifier}+Shift+4" = "move container to workspace number 4";
         "${modifier}+Shift+5" = "move container to workspace number 5";
         "${modifier}+Shift+6" = "move container to workspace number 6";
         "${modifier}+Shift+7" = "move container to workspace number 7";
         "${modifier}+Shift+8" = "move container to workspace number 8";
         "${modifier}+Shift+9" = "move container to workspace number 9";
         "${modifier}+0" = "scratchpad show";
         "${modifier}+1" = "workspace number 1";
         "${modifier}+2" = "workspace number 2";
         "${modifier}+3" = "workspace number 3";
         "${modifier}+4" = "workspace number 4";
         "${modifier}+5" = "workspace number 5";
         "${modifier}+6" = "workspace number 6";
         "${modifier}+7" = "workspace number 7";
         "${modifier}+8" = "workspace number 8";
         "${modifier}+9" = "workspace number 9";
         "${modifier}+Control+Shift+q" = "exec ${i3-gaps}/bin/i3-msg exit";
         "${modifier}+Ctrl+d" = "floating toggle";
         "${modifier}+v" = "split v";
         "${modifier}+minus" = "split h";
         "${modifier}+comma" = "mode desktop";
         "${modifier}+period" = "mode move-container";
         "${modifier}+i" = "focus child";
         "${modifier}+u" = "mode resize";
         "${modifier}+o" = "focus parent";
         "${modifier}+b" = "bar mode toggle";
   
         "${modifier}+h" = "focus left";
         "${modifier}+j" = "focus down";
         "${modifier}+k" = "focus up";
         "${modifier}+l" = "focus right";
         "${modifier}+Left" = "focus left";
         "${modifier}+Down" = "focus down";
         "${modifier}+Up" = "focus up";
         "${modifier}+Right" = "focus right";
   
         "${modifier}+Shift+h" = "move left";
         "${modifier}+Shift+j" = "move down";
         "${modifier}+Shift+k" = "move up";
         "${modifier}+Shift+l" = "move right";
         "${modifier}+Shift+Left" = "move left";
         "${modifier}+Shift+Down" = "move down";
         "${modifier}+Shift+Up" = "move up";
         "${modifier}+Shift+Right" = "move right";
   
         "${modifier}+Ctrl+h" = "resize shrink width 4px or 4 ppt";
         "${modifier}+Ctrl+j" = "resize grow height 4px or 4 ppt";
         "${modifier}+Ctrl+k" = "resize shrink height 4px or 4 ppt";
         "${modifier}+Ctrl+l" = "resize grow width 4px or 4 ppt";
         "${modifier}+Ctrl+Left" = "resize shrink width 4px or 4 ppt";
         "${modifier}+Ctrl+Down" = "resize grow height 4px or 4 ppt";
         "${modifier}+Ctrl+Up" = "resize shrink height 4px or 4 ppt";
         "${modifier}+Ctrl+Right" = "resize grow width 4px or 4 ppt";
   
         "${modifier}+Ctrl+f" = "fullscreen toggle";
         "${modifier}+Shift+Tab" = "workspace prev_on_output";
         "${modifier}+Shift+q" = "kill";
         "${modifier}+Tab" = "workspace next_on_output";
         "${modifier}+f" = "exec ${alacritty}/bin/alacritty -e ranger";
         "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
         "${modifier}+e" = "exec ${alacritty}/bin/alacritty -e vim";
         "${modifier}+grave" = "workspace back_and_forth";
         "${modifier}+Space" = "exec rofi -show drun";
         "${modifier}+r" = "exec rofi -show drun";
         "${modifier}+t" = "exec ${alacritty}/bin/alacritty";
         "${modifier}+w" = "exec ${firefox}/bin/firefox";
       };
     };
   };
   
   services.dunst = {
     enable = true;
     settings = {
       global = {
         geometry = "300x5-30+50";
         transparency = 10;
         frame_color = "#eceff1";
         font = "${defaultFont} 14";
       };
       urgency_normal = {
         background = "#37474f";
         foreground = "#eceff1";
         timeout = 10;
       };
     };
   };
   
   services.polybar = {
     enable = true;
     script = "polybar -q -r top & polybar -q -r bottom &";
     package = pkgs.polybar.override {
       i3GapsSupport = true;
       alsaSupport = true;
       ## iwSupport = true;
       ## githubSupport = true;
     };
   
     config = {
       "global/wm" = {
         margin-bottom = 0;
         margin-top = 0;
       };
   
       #====================BARS====================#
   
       "bar/top" = {
         bottom = false;
         fixed-center = true;
   
         width = "100%";
         height = 24;
         offset-x = "1%";
   
         scroll-up = "i3wm-wsnext";
         scroll-down = "i3wm-wsprev";
   
         background = bg;
         foreground = fg;
   
         radius = 0;
   
         font-0 = "TerminessTTF Nerd Font Mono:size=16;3";
         font-1 = "TerminessTTF Nerd Font Mono:style=Bold:size=16;3";
   
         modules-left = "distro-icon i3";
         modules-center = "title";
         modules-right = "audio date";
   
         locale = "en_US.UTF-8";
       };
   
       "bar/bottom" = {
         bottom = true;
         fixed-center = true;
   
         width = "100%";
         height = 19;
   
         offset-x = "1%";
   
         background = bg;
         foreground = fg;
   
         radius-top = 0;
   
         tray-position = "left";
         tray-detached = false;
         tray-maxsize = 15;
         tray-background = primary;
         tray-offset-x = -19;
         tray-offset-y = 0;
         tray-padding = 5;
         tray-scale = 1;
         padding = 0;
   
         font-0 = "TerminessTTF Nerd Font Mono:size=14;3";
         font-1 = "TerminessTTF Nerd Font Mono:style=Bold:size=14;3";
   
         modules-left = "powermenu ghe";
   
         modules-right = "cpu memory battery";
   
         locale = "en_US.UTF-8";
       };
   
       "settings" = {
         throttle-output = 5;
         throttle-output-for = 10;
         throttle-input-for = 30;
   
         screenchange-reload = true;
   
         compositing-background = "source";
         compositing-foreground = "over";
         compositing-overline = "over";
         comppositing-underline = "over";
         compositing-border = "over";
   
         pseudo-transparency = "false";
       };
   
       #--------------------MODULES--------------------"
       "module/distro-icon" = {
         type = "custom/script";
         exec = "${pkgs.coreutils}/bin/uname -r | ${pkgs.coreutils}/bin/cut -d- -f1";
         interval = 999999999;
   
         format = " <label>";
         format-foreground = quaternary;
         format-background = secondary;
         format-padding = 1;
         label = "%output%";
         label-font = 2;
       };
   
       "module/audio" = {
         type = "internal/alsa";
   
         format-volume = "墳 VOL <label-volume>";
         format-volume-padding = 1;
         format-volume-foreground = secondary;
         format-volume-background = tertiary;
         label-volume = "%percentage%%";
   
         format-muted = "<label-muted>";
         format-muted-padding = 1;
         format-muted-foreground = secondary;
         format-muted-background = tertiary;
         format-muted-prefix = "婢 ";
         format-muted-prefix-foreground = urgency;
         format-muted-overline = bg;
   
         label-muted = "VOL Muted";
       };
   
       "module/battery" = {
         type = "internal/battery";
         full-at = 101; # to disable it
         battery = "BAT0"; # TODO: Better way to fill this
         adapter = "AC0";
   
         poll-interval = 2;
   
         label-full = " 100%";
         format-full-padding = 1;
         format-full-foreground = secondary;
         format-full-background = primary;
   
         format-charging = " <animation-charging> <label-charging>";
         format-charging-padding = 1;
         format-charging-foreground = secondary;
         format-charging-background = primary;
         label-charging = "%percentage%% +%consumption%W";
         animation-charging-0 = "";
         animation-charging-1 = "";
         animation-charging-2 = "";
         animation-charging-3 = "";
         animation-charging-4 = "";
         animation-charging-framerate = 500;
   
         format-discharging = "<ramp-capacity> <label-discharging>";
         format-discharging-padding = 1;
         format-discharging-foreground = secondary;
         format-discharging-background = primary;
         label-discharging = "%percentage%% -%consumption%W";
         ramp-capacity-0 = "";
         ramp-capacity-0-foreground = urgency;
         ramp-capacity-1 = "";
         ramp-capacity-1-foreground = urgency;
         ramp-capacity-2 = "";
         ramp-capacity-3 = "";
         ramp-capacity-4 = "";
       };
   
       "module/cpu" = {
         type = "internal/cpu";
   
         interval = "0.5";
   
         format = " <label>";
         format-foreground = quaternary;
         format-background = secondary;
         format-padding = 1;
   
         label = "CPU %percentage%%";
       };
   
       "module/date" = {
         type = "internal/date";
   
         interval = "1.0";
   
         time = "%H:%M:%S";
         time-alt = "%Y-%m-%d%";
   
         format = "<label>";
         format-padding = 4;
         format-foreground = fg;
   
         label = "%time%";
       };
   
       "module/i3" = {
         type = "internal/i3";
         pin-workspaces = false;
         strip-wsnumbers = true;
         format = "<label-state> <label-mode>";
         format-background = tertiary;
   
         ws-icon-0 = "1;";
         ws-icon-1 = "2;";
         ws-icon-2 = "3;﬏";
         ws-icon-3 = "4;";
         ws-icon-4 = "5;";
         ws-icon-5 = "6;";
         ws-icon-6 = "7;";
         ws-icon-7 = "8;";
         ws-icon-8 = "9;";
         ws-icon-9 = "10;";
   
         label-mode = "%mode%";
         label-mode-padding = 1;
   
         label-unfocused = "%icon%";
         label-unfocused-foreground = quinternary;
         label-unfocused-padding = 1;
   
         label-focused = "%index% %icon%";
         label-focused-font = 2;
         label-focused-foreground = secondary;
         label-focused-padding = 1;
   
         label-visible = "%icon%";
         label-visible-padding = 1;
   
         label-urgent = "%index%";
         label-urgent-foreground = urgency;
         label-urgent-padding = 1;
   
         label-separator = "";
       };
   
       "module/title" = {
         type = "internal/xwindow";
         format = "<label>";
         format-foreground = secondary;
         label = "%title%";
         label-maxlen = 70;
       };
   
       "module/memory" = {
         type = "internal/memory";
   
         interval = 3;
   
         format = " <label>";
         format-background = tertiary;
         format-foreground = secondary;
         format-padding = 1;
   
         label = "RAM %percentage_used%%";
       };
   
       "module/network" = {
         type = "internal/network";
         interface = "enp3s0";
   
         interval = "1.0";
   
         accumulate-stats = true;
         unknown-as-up = true;
   
         format-connected = "<label-connected>";
         format-connected-background = mf;
         format-connected-underline = bg;
         format-connected-overline = bg;
         format-connected-padding = 2;
         format-connected-margin = 0;
   
         format-disconnected = "<label-disconnected>";
         format-disconnected-background = mf;
         format-disconnected-underline = bg;
         format-disconnected-overline = bg;
         format-disconnected-padding = 2;
         format-disconnected-margin = 0;
   
         label-connected = "D %downspeed:2% | U %upspeed:2%";
         label-disconnected = "DISCONNECTED";
       };
   
       "module/temperature" = {
         type = "internal/temperature";
   
         interval = "0.5";
   
         thermal-zone = 0; # TODO: Find a better way to fill that
         warn-temperature = 60;
         units = true;
   
         format = "<label>";
         format-background = mf;
         format-underline = bg;
         format-overline = bg;
         format-padding = 2;
         format-margin = 0;
   
         format-warn = "<label-warn>";
         format-warn-background = mf;
         format-warn-underline = bg;
         format-warn-overline = bg;
         format-warn-padding = 2;
         format-warn-margin = 0;
   
         label = "TEMP %temperature-c%";
         label-warn = "TEMP %temperature-c%";
         label-warn-foreground = "#f00";
       };
   
       "module/powermenu" = {
         type = "custom/menu";
         expand-right = true;
   
         format = "<label-toggle> <menu>";
         format-background = secondary;
         format-padding = 1;
   
         label-open = "";
         label-close = "";
         label-separator = "  ";
   
         menu-0-0 = " Suspend";
         menu-0-0-exec = "systemctl suspend";
         menu-0-1 = " Reboot";
         menu-0-1-exec = "v";
         menu-0-2 = " Shutdown";
         menu-0-2-exec = "systemctl poweroff";
       };
     };
   };
   */

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    settings.prompt = "enabled";
    settings.browser = "firefox";
    settings.aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
  };

  programs.rofi = {
    enable = true;
    pass.enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      modi = "drun,ssh,window";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
    };
    package = pkgs.rofi.override {
      plugins = [pkgs.rofi-pass];
    };
  };

  programs.git = lib.mkDefault {
    delta.enable = true;
    enable = true;
    ignores = ["*~" "tags" ".nvimlog" "*.swp" "*.swo" "*.log" ".DS_Store"];
    userEmail = "developer+no-reply@fnctl.io";
    userName = "Developer";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings.date = "relative";
    settings.ignore-globs = [".git" ".hg"];
  };

  /*
   *
   *** Miscellaneous Ad-hoc Configurations.
   *
   */
  programs.command-not-found.enable = false;
  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.gpg.enable = true;
  programs.password-store.enable = true;
}
