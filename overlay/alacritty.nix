{ writeText, writeShellApplication, alacritty, terminus-nerdfont, xcwd, lib, ... }:
writeShellApplication {
    name = "alacritty";
    runtimeInputs = [ alacritty terminus-nerdfont xcwd ];
    inherit (alacritty) passthru;
    text = let 
      config = rec {
        env = {
          TERM = "alacritty";
        };
        font = {
          normal.family = "TerminessTTF Nerd Font Mono";
          size = 9.0;
          builtin_box_drawing = false;
          use_thin_strokes = true;
          offset.x = 1;
          offset.y = 1;
          glyph_offset.x = 1;
          glyph_offset.y = 1;
        };
      };
    in lib.concatStringsSep " " [
      "exec alacritty" 
      "--config-file='${writeText "alacritty.yml" (builtins.toJSON config)}'" 
      "--working-directory=\"$(xcwd)\"" 
      "\"$@\""
    ];
  }
