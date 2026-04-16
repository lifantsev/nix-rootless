# Installing Nix
[https://nixos.wiki/wiki/Nix_Installation_Guide#Installing_without_root_permissions](guide for rootless nix installation)

We'll use [nix-user-chroot](https://github.com/nix-community/nix-user-chroot). Download a [prebuilt binary](https://github.com/nix-community/nix-user-chroot/releases):
```
# replace <url> with the url of a binary from the releases page, should look something like:
# https://github.com/nix-community/nix-user-chroot/releases/download/2.1.1/nix-user-chroot-bin-2.1.1-x86_64-unknown-linux-musl
curl -L <url> -o ~/.local/bin/nix-user-chroot
```

Now let's create the nix store and install the nix utility suite.
```
mkdir -m 0755 ~/.nix
~/.local/bin/nix-user-chroot ~/.nix bash -c 'curl -L https://nixos.org/nix/install | sh'
```

Now you can enter a chrooted shell and verify nix is installed:
```
~/.local/bin/nix-user-chroot ~/.nix $SHELL -l
nix --version
```

Switch off of unstable nixpkgs (use latest [stable release](https://channels.nixos.org/) instead) here I'll use 25.11:
```
nix-channel --remove nixpkgs
nix-channel --add https://channels.nixos.org/nixos-25.11 nixpkgs
nix-channel --list # check that changes have applied
nix-channel --update # this will take a while to run
```

# Installing Home Manager
[https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone](home-manager standalone installation guide)

Add the home manager channel, using the same version number as your nixpkgs channel:
```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update # this will take a while
```

Install home manager:
```
nix-shell '<home-manager>' -A install # this will take a while
```

# Finishing the bootstrap
At this point, we have nix installed using nix-env, but it would be nice to manage it with home-manager (to use settings like nix.settings.experimental-features). In order to do this, we have to uninstall it from nix-env and simultaneously install it from home-manager. First ensure these lines are present in your `home.nix`:
```
home.packages = [ # let home-manager manage nix installation
    pkgs.nix
];

programs.home-manager.enable = true; # let home-manager manage itself
```

Then run these commands to 'hand off' control to home-manager:
```
nix-shell -p nix home-manager # create a temporary subshell where we have access to nix & home-manager

in subshell: nix-env -e nix home-manager-path # remove packages
in subshell: nix-env -q                       # check packages are removed (should output nothing)
in subshell: home-manager switch              # install packages
in subshell: exit

nix --version # verify nix is still installed
```

# Running nix-user-chroot on login
It would be nice not to have to run `nix-user-chroot` on every login. Add these lines to your ~/.profile to automatically run it:
```
if [ "$IN_NIX_CHROOT" != 1 ]; then
    export IN_NIX_CHROOT=1
    exec ~/.local/bin/nix-user-chroot ~/.nix $SHELL -l
fi
```
We don't use home manager to manage ~/.profile because it would create a symlink that is only valid inside the chroot.

# Configuring
Configure home-manager as you would [usually](https://nix-community.github.io/home-manager/index.xhtml#ch-usage) (editing the home.nix file). To apply changes run:
```
home-manager switch
```

# Using flakes
If you followed the steps above you are using nix channels to provide things like nixpkgs and home-manager. This isn't ideal because nothing in your configuration files indicates which version of nixpkgs they are meant for. Let's say your laptop breaks and now you are reinstalling your config on a new machine. Nothing in your configuration repo tells you what nixpkgs version to use. Flakes fix this, because they pin the exact version of every input in a flake.lock file. This makes rolling back to old versions a lot easier.

To switch to flakes, first refactor your configuration. There are many guides available but in short, create a `flake.nix`, add `nixpkgs and home-manager` to `inputs`, add `homeConfigurations` to `ouputs` and point it to your `home.nix`. Take a look at this repo's `flake.nix` for reference.

Then `nix flake update` to create a `flake.lock` and cache inputs. Finally use `home-manager switch --flake .` to rebuild your config.

Now that nixpkgs and home-manager are managed by your flake, you can remove the channels:
```
nix-channel --remove nixpkgs
nix-channel --remove home-manager
```

# Installing this specific configuration
First clone the repo into some folder.
