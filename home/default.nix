{ pkgs, ... }: {
    home.username = "marklif";
    home.homeDirectory = "/w/home.19/home/marklif";

    imports = [
        ./lf
        ./zsh
        ./git.nix
        ./gpg.nix
    ];

    home.packages = with pkgs; [
        (pkgs.writeShellScriptBin "copy" ''
            b64=$(printf "%s" "$1" | base64 | tr -d '\n')
            printf "\033]52;c;%s\007" "$b64" > /dev/tty
            '')

        neovim
        lf trash-cli
        zsh

        eza

        nix
    ];

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    nix = {
        package = pkgs.nix;
        # TODO look into settings.auto-optimize-store
        settings = {
            experimental-features = [ "flakes" "nix-command" ];

            extra-substituters = [ "https://lifantsev-nixvim.cachix.org" ];
            extra-trusted-public-keys = [ "lifantsev-nixvim.cachix.org-1:YrToDOQcRnfUaXmkCBgF4nN4Znsvq/tCCX1pISSmFm0=" ];
        };
    };

    # WARN DONT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING
    home.stateVersion = "25.11"; # Did you read the comment?

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
