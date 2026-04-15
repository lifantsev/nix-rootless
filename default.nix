{ config, pkgs, lib, ... }: {
    home.username = "marklif";
    home.homeDirectory = "/w/home.19/home/marklif";

    imports = let
        imports = lib.attrsets.filterAttrs
            (n: v: (v == "directory" && n != ".git")
                || (v == "regular" && n != "default.nix" && lib.hasSuffix ".nix" n))
            (builtins.readDir ./.);
    in map (name: ./. + "/${name}") (builtins.attrNames imports);

    home.packages = with pkgs; [
        neovim
        zsh

        eza

        (pkgs.writeShellScriptBin "copy" ''
            b64=$(printf "%s" "$1" | base64 | tr -d '\n')
            printf "\033]52;c;%s\007" "$b64" > /dev/tty
        '')
    ];

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    # WARN DONT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING
    home.stateVersion = "25.11"; # Did you read the comment?

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
