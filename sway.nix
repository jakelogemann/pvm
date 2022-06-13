{
  config,
  pkgs,
  lib,
  ...
}:
with pkgs; {
  hardware.opengl.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      wl-clipboard
      mako
      waybar
      swaylock
      swaycwd
      sway-contrib.grimshot
      swayidle
      wofi
      foot
      dmenu
      alacritty
    ];
    extraSessionCommands = ''
      # SDL:
      export SDL_VIDEODRIVER=wayland
      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  environment.etc."sway/config.d/mako.conf".source =
    writeText "mako.conf" "\nexec mako\n";

  environment.etc."sway/config.d/inputs.conf".source = writeText "inputs.conf" ''
    input type:keyboard {
      xkb_options ctrl:nocaps
      repeat_delay 350
      repeat_rate 25
    }
  '';
}
