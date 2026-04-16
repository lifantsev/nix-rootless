{ config, ... }: {
    xdg.configFile."lf/colors".source = ./colors;
    xdg.configFile."lf/scripts".source = ./scripts;

    programs.lf = let scriptdir = "${config.xdg.configHome}/lf/scripts"; in {
        enable = true;

        keybindings = import ./binds.nix;
        settings = import ./options.nix scriptdir;
        commands = import ./commands.nix scriptdir;
    };
}
