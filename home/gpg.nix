{ pkgs, ... }@args: {
    programs.gpg.enable = true;

    # NOTE after changing anything, run `gpgconf --reload gpg-agent` to apply
    # idk why this isn't in an activation script :/
    services.gpg-agent = let
        timeout = 60*60*1; # 1 hour
    in {
        enable = true;
        pinentry.package = pkgs.pinentry-tty;

        extraConfig = ''
            allow-loopback-pinentry
        '';

        enableSshSupport = true;
        sshKeys = [ "B37F740BB34F8DDE055D89151BAF40DE27F5B630" ];

        enableZshIntegration = true;

        defaultCacheTtl = timeout; # seconds
        defaultCacheTtlSsh = timeout;
        maxCacheTtl = timeout;
        maxCacheTtlSsh = timeout;
    };
}

