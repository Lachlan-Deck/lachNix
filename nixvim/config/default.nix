{
  imports = [
    ./cmp.nix
    ./options.nix
    ./treesitter.nix
    ./oil.nix

    ./lsp/default.nix
    ./lsp/none-ls.nix
    ./lsp/trouble.nix

    ./utils/autosave.nix
    ./utils/telescope.nix
    ./utils/which-key.nix

    ./utils/harpoon.nix
    ./utils/fugitive.nix
    ./utils/twilight.nix
    ./utils/markdown-preview.nix
    ./utils/image.nix
    ./utils/zenMode.nix
    ./utils/leap.nix
  ];
  colorschemes.kanagawa = {
    enable = true;

    settings = {
      compile = false;
      undercurl = true;
      commentStyle.italic = true;
      functionStyle = { };
      transparent = false;
      dimInactive = true;
      terminalColors = false;
      colors = {
        theme = {
          wave.ui.float.bg = "none";
          dragon.syn.parameter = "yellow";
          all.ui.bg_gutter = "none";
        };
        palette = {
          sumiInk0 = "#000000";
          fujiWhite = "#FFFFFF";
        };
      };
      overrides = "function(colors) return {} end";
      theme = "wave";
    };
  };
  diagnostics = { virtual_lines.only_current_line = true; };

  extraConfigVim = ''
    autocmd BufRead,BufNewFile *.pl set filetype=prolog
    '';

  globals.mapleader = ",";
  keymaps = [
    # Global
    # Default mode is "" which means normal-visual-op
    {
      key = "<C-n>";
      action = "<CMD>NvimTreeToggle<CR>";
      options.desc = "Toggle NvimTree";
    }
    {
      key = "<leader>c";
      action = "+context";
    }
    {
      key = "<leader>co";
      action = "<CMD>TSContextToggle<CR>";
      options.desc = "Toggle Treesitter context";
    }
    {
      key = "_";
      action = "<CMD>Oil<CR>";
      options.desc = "opens oil in cwd";
    }

    # File
    {
      mode = "n";
      key = "<leader>f";
      action = "+find/file";
    }
    {
      # Format file
      key = "<leader>fm";
      action = "<CMD>lua vim.lsp.buf.format()<CR>";
      options.desc = "Format the current buffer";
    }

    # Git    
    {
      mode = "n";
      key = "<leader>g";
      action = "+git";
    }
    {
      mode = "n";
      key = "<leader>gt";
      action = "+toggles";
    }

    # Trouble 
    {
      mode = "n";
      key = "<leader>d";
      action = "+diagnostics/debug";
    }
    {  
      key = "<leader>dt";
      action = "<CMD>TroubleToggle<CR>";
      options.desc = "Toggle trouble";
    }
  ];
}
