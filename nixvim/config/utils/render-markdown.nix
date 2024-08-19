
{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    render-markdown
  ];
}
