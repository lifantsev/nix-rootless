{ config, ... }@args: {
    # NOTE default shell is set in ~/.shrc

    programs.fzf.enableZshIntegration = true;
    services.gpg-agent.enableZshIntegration = true;

    programs.zsh = {
        enable = true;
        dotDir = "${config.home.homeDirectory}/.config/zsh";

        enableCompletion = false;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        sessionVariables = {
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=7";
        };
        
        history = {
            path = "$ZDOTDIR/.zsh_history";
            size = 10000;
            save = 10000;
            extended = true;
            share = true; # shared hist between files
        };

        shellAliases = (import ./alias/git.nix) // (import ./alias/other.nix);

        initContent = /*sh*/ ''
            # fallback when missing terminfo
            if ! infocmp "$TERM" >/dev/null 2>&1; then
                export TERM=xterm-256color
            fi

            ${builtins.readFile ./function/extract.sh}
            ${builtins.readFile ./function/helpers.sh}

            ${builtins.readFile ./bind/binds.zsh}
            ${builtins.readFile ./bind/lazy-comp-init.zsh}
        '';
    };

    programs.starship.enableZshIntegration = true;
    programs.starship = {
        enable = true;
        settings = let
            dirstyle      = "blue";
            gitstyle      = "purple";
            gitstylealt   = "red";
        in {
            add_newline = true;
            format = "$git_status$directory";

            directory = {
                truncation_length = 0;
                truncate_to_repo = true;

                format = "[$path](${dirstyle}) ";
            };

            git_status = {
                format = "[$ahead_behind](${gitstyle})[$all_status](${gitstylealt}) ";

                up_to_date = "->";
                ahead      = ">>";
                behind     = "<<";
                conflicted = "><";
                diverged   = "><";

                untracked = " nw";
                stashed   = " $$";
                modified  = " ch";
                staged    = " gc";
                renamed   = " mv";
                deleted   = " rm";
            };
        };
    };
}
