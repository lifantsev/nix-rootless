a() {
    lastdir="$(lf -print-last-dir "$1")"
    if [ -f /tmp/lfcd ]; then e "$lastdir" ; rm /tmp/lfcd; fi
}
hm() {
    echo "running home-manager switch..."
    home-manager switch -f ~/nix-rootless/
}
hmdd() {
    echo "removing all but current generation..."
    home-manager expire-generations "-0 days"
    nix-collect-garbage -d
}
qta() {
    . /etc/profile
    quota -s 2>/dev/null
}
n() {
    if [ "$(ls -a | wc -l)" -gt 20 ];
    then eza -al --no-user --no-permissions --no-filesize --no-time -G
    else eza -al --no-user --no-permissions --no-filesize --no-time
    fi
}
e() { 
    cd "$@" || return
    n
}
k() { mkdir -p "$@"; }
ke() { k "$1" && e "$1"; }
h() { if [ -z "$1" ]; then $EDITOR . ;else $EDITOR "$@"; fi }
