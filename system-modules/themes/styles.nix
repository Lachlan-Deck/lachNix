{ pkgs, ... }: 

let commitMono-lach = import ./fonts/commitMono-lach.nix { inherit pkgs; };
in {
  stylix = {
    homeManagerIntegration.followSystem = true;
    enable = true;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    image = ./Constitution-Dock.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/mellow-purple.yaml";

    fonts = {
        
      monospace = { 
        package = commitMono-lach;
        name = "commitMono-lach";  
      };
      sansSerif = {
        package = commitMono-lach;
        name = "commitMono-lach";  
      };
        
      serif = {
        package = commitMono-lach;
        name = "commitMono-lach";   
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

  };
}
