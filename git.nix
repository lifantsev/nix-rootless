{ pkgs, ... }: {
    programs.git = {
        enable = true;
        settings = {
            user.name = "Mark Lifantsev";
            user.email = "marklif@ucla.edu";

            init.defaultBranch = "main";
            commit.gpgsign = true;
            tag.forceSignAnnotated = true;

            # update gpg tty so that gpg-agent binds pinentry to correct term
            core.sshCommand = "${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1; ssh";
        };
    };
    

    programs.diff-so-fancy = {
        enable = true;
        enableGitIntegration = true;

        pagerOpts = [ "--tabs=4" "-R" "-F" ];

        settings = {
            useUnicodeRuler = true;
            markEmptyLines = false;
        };
    };
}
