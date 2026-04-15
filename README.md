# Installing Nix
[https://nixos.wiki/wiki/Nix_Installation_Guide#Installing_without_root_permissions](guide for rootless nix installation)

We'll use [nix-user-chroot](https://github.com/nix-community/nix-user-chroot). Download a [prebuilt binary](https://github.com/nix-community/nix-user-chroot/releases) using `curl -L <url> -o ~/.local/bin/nix-user-chroot`.

Now lets create the nix store and install the nix utility suite.
```
mkdir -m 0755 ~/.nix
nix-user-chroot ~/.nix bash -c 'curl -L https://nixos.org/nix/install | sh'
```

Now you can enter a chrooted shell using:
```
nix-user-chroot .nix bash -l
nix --version # check that nix is installed
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

# Configuring Home Manager
See (hm usage)[https://nix-community.github.io/home-manager/index.xhtml#ch-usage] for more info.

I personally like to have my configuration in a folder in $HOME, so here's how to transfer the configuration:
```
mkdir -p ~/nix-rootless
cat ~/.config/home-manager/home.nix > ~/nix-rootless/default.nix
rm -r ~/.config/home-manager # remove old file
```

Now to test that everything is working right we run this command. This is the command you run to apply any changes made in your configuration.
```
home-manager switch -f ~/nix-rootless
```

# Running nix-user-chroot on login
It would be nice not to have to run `nix-user-chroot` on every login. Let's modify ~/.profile to automatically run it. Add these lines:
```
export ENV=$HOME/.shrc

if [ "$IN_NIX_CHROOT" != 1 ]; then
    export IN_NIX_CHROOT=1
    export SH_LOGGING_IN=1
    exec ~/.local/bin/nix-user-chroot ~/.nix sh -l
fi
```
and in .shrc:
```
if [ "$SH_LOGGING_IN" == 1 ]; then
    export SH_LOGGING_IN=0
    exec zsh -l
fi
```
Note, the reason we don't use home manager to make this change is because then .profile would be a symlink that is only valid under the chroot, but .profile will have to be ran outside of the chroot.
