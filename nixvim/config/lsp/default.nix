{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        gleam.enable = true;
        nixd.enable = true;
        java-language-server.enable = true;
      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
    };
    rust-tools.enable = true;
  };
}
