inputs: final: prev: with prev; {
  alacritty = writeShellApplication {
    name = "alacritty";
    runtimeInputs = [ alacritty terminus-nerdfont xcwd ];
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
  };

  neovim = (neovim.override {
      vimAlias = true;
      viAlias = true;
      configure = {
        packages.default = with vimPlugins; {
          opt = [];
          start = [ 
            vim-lastplace 
            # nvim-tree-lua
            telescope-nvim
            nvim-lspconfig
            vim-nix 
            nvim-web-devicons 
            i3config-vim
            vim-easy-align 
            vim-gnupg
            vim-cue
            vim-go
            vim-hcl
            # which-key-nvim
            # toggleterm-nvim
            (nvim-treesitter.withPlugins (p: builtins.map (n: p."tree-sitter-${n}") [
              "bash" 
              "c"
              "comment"
              "cpp" 
              "css" 
              "go"
              "html" 
              "json" 
              "lua"
              "make"
              "markdown"
              "nix"
              "python"
              "ruby"
              "rust"
              "toml"
              "vim"
              "yaml"
            ]))
            onedarkpro-nvim
          ]; 
        };
        customRC = ''
          colorscheme onedarkpro
          set number nobackup noswapfile tabstop=2 shiftwidth=2 softtabstop=2 nocompatible autoread
          set expandtab smartcase autoindent nostartofline hlsearch incsearch mouse=a
          set cmdheight=2 wildmenu showcmd cursorline ruler spell foldmethod=syntax
          set backspace=indent,eol,start background=dark
          let mapleader=' '
          if has("user_commands")
            command! -bang -nargs=? -complete=file E e<bang> <args>
            command! -bang -nargs=? -complete=file W w<bang> <args>
            command! -bang -nargs=? -complete=file Wq wq<bang> <args>
            command! -bang -nargs=? -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
          endif
          function! NumberToggle()
            if(&relativenumber == 1) set nu nornu
            else set nonu rnu 
            endif
          endfunc
          nnoremap <leader>r :call NumberToggle()<cr>
          nnoremap <silent> <C-e> <CMD>NvimTreeToggle<CR>
          nnoremap <silent> <leader>e <CMD>NvimTreeToggle<CR>
          nnoremap <silent> <leader><leader>f <CMD>Telescope find_files<CR>
          nnoremap <silent> <leader><leader>r <CMD>Telescope symbols<CR>
          nnoremap <silent> <leader><leader>R <CMD>Telescope registers<CR>
          nnoremap <silent> <leader><leader>z <CMD>Telescope current_buffer_fuzzy_find<CR>
          nnoremap <silent> <leader><leader>m <CMD>Telescope marks<CR>
          nnoremap <silent> <leader><leader>H <CMD>Telescope help_tags<CR>
          nnoremap <silent> <leader><leader>M <CMD>Telescope man_pages<CR>
          nnoremap <silent> <leader><leader>c <CMD>Telescope commands<CR>
        '';
      };
    }
  );

}
