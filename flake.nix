{
  description = "fnctl/pvm";
  inputs.mkSystem.url = "github:fnctl/mkSystem";

  inputs.fnctl = {
    inputs.fnctl-lib.follows = "mkSystem/fnctl-lib";
    inputs.nixpkgs.follows = "mkSystem/nixpkgs";
    inputs.nix.follows = "mkSystem/nix";
    inputs.home-manager.follows = "mkSystem/home-manager";
    url = "github:fnctl/fnctl";
    # url = "/media/psf/fnctl";
  };

  outputs = {self, ...}:
    with self.inputs.mkSystem; {
      formatter = inputs.fnctl-lib.formatter;
      nixosConfigurations.fnctl = let
        userName = "developer";
        groupName = "fnctl";
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
      in
        mkSystem rec {
          system = "aarch64-linux";
          modules = [
            ({
              config,
              pkgs,
              lib,
              ...
            }: {
              disabledModules = ["virtualisation/parallels-guest.nix"];
              imports = [
                ./parallels-guest.nix
              ];

              fileSystems."/" .fsType = "ext4";
              fileSystems."/".device = "/dev/disk/by-label/nixos";
              fileSystems."/boot".device = "/dev/disk/by-label/boot";
              fileSystems."/boot".fsType = "vfat";
              fonts.enableDefaultFonts = true;
              networking.interfaces.enp0s5.useDHCP = true;
              nix.allowedUsers = [userName];
              security.sudo.wheelNeedsPassword = lib.mkForce false;
              users.groups.${groupName} = {};
              users.groups.docker = {};
              users.groups.wheel = {};
              users.users.${userName} = {
                initialPassword = "${userName}l33t${groupName}!";
                isNormalUser = true;
                group = groupName;
                extraGroups = ["users" "docker" "wheel"];
                packages = with pkgs; [
                  (pkgs.writeShellScriptBin "system" "sudo nixos-rebuild --install-bootloader \"\$@\"")
                  (pkgs.writeShellScriptBin "system-edit" "cd /etc/nixos && \$EDITOR \"\$@\"")
                  (pkgs.writeShellScriptBin "system-update" "cd /etc/nixos && sudo nix flake update \"\$@\"")
                  (pkgs.writeShellScriptBin "system-git" "cd /etc/nixos && sudo git \"\$@\"")
                  (pkgs.writeShellScriptBin "system-fmt" "cd /etc/nixos && sudo nix fmt \"\$@\"")
                  alejandra
                  jq
                  nix-direnv
                  ranger
                  ripgrep
                  ssh-copy-id
                  tmux
                  tree
                  unrar
                  unzip
                  yq
                  (symlinkJoin {
                    name = "desktop";
                    postBuild = "echo links added";
                    paths = [
                      wlsunset
                      light
                      alacritty
                      firefox
                      rofi
                      zathura
                      wl-clipboard
                      sway
                      swaycwd
                      swayidle
                      swaylock
                      wl-color-picker
                      terminus-nerdfont
                      xkcd-font
                      hack-font
                      sway-contrib.grimshot
                    ];
                  })
                ];
              };

              environment.variables.EDITOR = "nvim";
              environment.systemPackages = with pkgs; [
                self.inputs.fnctl.outputs.packages.${pkgs.system}.neovim
              ];

              home-manager.sharedModules = [
                ({...}: {
                  fonts.fontconfig.enable = true;
                  home.enableNixpkgsReleaseCheck = false;
                  xdg.enable = true;
                  xdg.mime.enable = true;
                  xdg.mimeApps.enable = true;
                  xdg.userDirs.documents = "$HOME/My/Documents";
                  xdg.userDirs.download = "$HOME/My/Downloads";
                  xdg.userDirs.music = "$HOME/My/Music";
                  xdg.userDirs.videos = "$HOME/My/Videos";
                  xdg.userDirs.templates = "$HOME/My/Templates";
                  xdg.userDirs.pictures = "$HOME/My/Pictures";
                  xdg.userDirs.publicShare = "/var/empty";
                  xdg.userDirs.extraConfig.XDG_MISC_DIR = "$HOME/Misc";

                  xdg.desktopEntries.example = {
                    name = "Example";
                    genericName = "Example";
                    exec = "firefox %U";
                    terminal = false;
                    categories = ["Application"];
                    mimeType = ["text/html"];
                  };

                  xdg.desktopEntries.terminal = {
                    name = "Terminal ";
                    genericName = "Terminal ";
                    terminal = false;
                    categories = ["Application"];
                    mimeType = ["text/html"];
                    exec = "bash -c ${(pkgs.writeShellScript "launch-terminal" ''
                      exec alacritty --working-directory=$(swaycwd)
                    '')}";
                  };

                  xdg.desktopEntries.editor = {
                    name = "Editor";
                    genericName = "Editor";
                    terminal = false;
                    categories = ["Application"];
                    mimeType = ["text/plain"];
                    exec = "bash -c ${(pkgs.writeShellScript "launch-terminal" ''
                      exec alacritty --working-directory=$(swaycwd) -e "$EDITOR"
                    '')}";
                  };

                  xdg.desktopEntries.ranger = rec {
                    name = "Ranger";
                    genericName = name;
                    terminal = false;
                    categories = ["Application"];
                    mimeType = ["text/plain"];
                    exec = "bash -c ${(pkgs.writeShellScript "launch-terminal" ''
                      exec alacritty --working-directory=$(swaycwd) -e "$EDITOR"
                    '')}";
                  };

                  programs.waybar = {
                    enable = true;
                    settings.mainBar.layer = "top";
                    settings.mainBar.position = "top";
                    settings.mainBar.height = 30;
                    settings.mainBar.output = ["Virtual-1"];
                    settings.mainBar.modules-left = ["sway/workspaces" "sway/mode" "wlr/taskbar"];
                    settings.mainBar.modules-center = ["sway/window"];
                    settings.mainBar.modules-right = ["temperature"];
                    settings.mainBar."sway/workspaces".disable-scroll = true;
                    settings.mainBar."sway/workspaces".all-outputs = true;
                  };

                  wayland.windowManager.sway = let
                    modifier = "Mod4";
                  in {
                    enable = true;
                    swaynag.enable = true;
                    wrapperFeatures.gtk = true;
                    wrapperFeatures.base = true;
                    extraSessionCommands = ''
                      export SDL_VIDEODRIVER=wayland
                      export QT_QPA_PLATFORM=wayland-egl
                      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
                      export _JAVA_AWT_WM_NONREPARENTING=1
                      export WLR_NO_HARDWARE_CURSORS=0
                    '';
                    config = {
                      inherit modifier;
                      assigns."1: web" = [{class = "^Firefox$";}];
                      assigns."0: extra" = [
                        {
                          class = "^Firefox$";
                          window_role = "About";
                        }
                      ];

                      floating.titlebar = false;
                      fonts.names = [defaultFont];
                      fonts.size = 14.0;
                      fonts.style = "Bold Semi-Condensed";
                      gaps.smartBorders = "no_gaps";
                      gaps.smartGaps = false;
                      input."*".natural_scroll = "disabled";
                      input."*".xkb_capslock = "disable";
                      input."*".xkb_numlock = "disable";
                      input."*".xkb_options = "ctrl:nocaps";
                      input."type:touchpad".tap = "enabled";
                      modes.desktop."Escape" = "mode default";
                      modes.desktop."Return" = "mode default";
                      modes.desktop."Shift+q" = "swaymsg exit";
                      modes.desktop."Shift+r" = "swaymsg restart";
                      modes.desktop."r" = "swaymsg reload";
                      output.Virtual-1.mode = "1920x1080@60Hz";
                      output.Virtual-1.render_bit_depth = "8";
                      window.border = 4;
                      workspaceAutoBackAndForth = true;
                      workspaceLayout = "default";

                      modes.move-container = {
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

                      modes.resize = {
                        "Left" = "resize shrink width 10 px or 10 ppt";
                        "Down" = "resize grow height 10 px or 10 ppt";
                        "Up" = "resize shrink height 10 px or 10 ppt";
                        "Right" = "resize grow width 10 px or 10 ppt";
                        "Escape" = "mode default";
                        "Return" = "mode default";
                      };

                      keybindings = {
                        "XF86Display" = "exec xrandr --output eDP-1 --auto --output DP-1 --off --output DP-2 --off --output HDMI-1 --off";
                        "${modifier}+XF86Display" = "exec xrandr --output eDP-1 --off --output DP-1 --auto --output DP-2 --auto --output HDMI-1 --auto";
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
                        "${modifier}+Control+Shift+q" = "exec swaymsg exit";
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
                        "${modifier}+f" = "exec alacritty -e ranger";
                        "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
                        "${modifier}+e" = "exec alacritty -e vim";
                        "${modifier}+grave" = "workspace back_and_forth";
                        "${modifier}+Space" = "exec rofi -show drun";
                        "${modifier}+r" = "exec rofi -show drun";
                        "${modifier}+t" = "exec alacritty";
                        "${modifier}+w" = "exec firefox";
                      };
                    };
                  };

                  programs.bat.enable = true;
                  programs.command-not-found.enable = false;
                  programs.direnv.enable = true;
                  programs.gh.enable = true;
                  programs.gh.settings.aliases.co = "pr checkout";
                  programs.gh.settings.aliases.pv = "pr view";
                  programs.gh.settings.browser = "firefox";
                  programs.gh.settings.git_protocol = "ssh";
                  programs.gh.settings.prompt = "enabled";
                  programs.git.delta.enable = true;
                  programs.git.enable = true;
                  programs.git.ignores = ["*~" "tags" ".nvimlog" "*.swp" "*.swo" "*.log" ".DS_Store"];
                  programs.git.userEmail = "developer+no-reply@fnctl.io";
                  programs.git.userName = "Developer";
                  programs.gpg.enable = true;
                  programs.lsd.enable = true;
                  programs.lsd.enableAliases = true;
                  programs.lsd.settings.date = "relative";
                  programs.lsd.settings.ignore-globs = [".git" ".hg"];
                  programs.password-store.enable = true;
                  programs.rofi.enable = true;
                  programs.rofi.extraConfig.kb-primary-paste = "Control+V,Shift+Insert";
                  programs.rofi.extraConfig.kb-secondary-paste = "Control+v,Insert";
                  programs.rofi.extraConfig.modi = "drun,ssh,window,pass";
                  programs.rofi.package = with pkgs; rofi.override {plugins = [rofi-pass];};
                  programs.rofi.pass.enable = true;
                  programs.rofi.terminal = getExe pkgs.alacritty;
                  services.dunst.enable = true;
                  services.dunst.settings.global.font = "${defaultFont} 14";
                  services.dunst.settings.global.frame_color = "#eceff1";
                  services.dunst.settings.global.geometry = "300x5-30+50";
                  services.dunst.settings.global.transparency = 10;
                  services.dunst.settings.urgency_normal.background = "#37474f";
                  services.dunst.settings.urgency_normal.foreground = "#eceff1";
                  services.dunst.settings.urgency_normal.timeout = 10;
                  services.gpg-agent.defaultCacheTtl = 1800;
                  services.gpg-agent.enable = true;
                  services.gpg-agent.enableSshSupport = true;
                })
              ];
              programs.zsh.interactiveShellInit = ''
                autoload -Uz promptinit colors bashcompinit compinit && compinit && bashcompinit && promptinit && colors
              '';
            })
          ];
        };
    };
}
# vim: fen fdl=3

