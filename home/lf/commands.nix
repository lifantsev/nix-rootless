scriptdir: {
    custom_open = ''%${scriptdir}/opener'';
    custom_quitcd = ''%touch /tmp/lfcd && lf --remote "send $id quit"'';

    # XIOXIDE STUFF

    custom_ee = "cd ~";
    custom_eo = ''%lf -remote "send $id cd \"$OLDPWD\""'';

    # FILE MANIPULATION

    custom_mkdir = /*sh*/ ''%{{
        printf " dir name: "
        read ans
        mkdir -p "$ans"
    }}'';

    custom_touch = /*sh*/ ''%{{
        printf " file name: "
        read ans
        touch "$ans"
        echo -e '\n' > "$ans"
    }}'';

    custom_chmod = /*sh*/ ''%{{
        printf " chmod bits: "
        read ans
        for file in "$fx"; do
        chmod "$ans" "$file"
        done
        lf -remote 'send reload'
    }}'';

    custom_trash = let
        file = "\${files%%;*}";
        files = "\${files#*;}";
    in /*sh*/ ''%{{
        files=$(printf "$fx" | tr '\n' ';')

        while [ "$files" ]; do
            # grab one file from 'files'
            file=${file}

            # remove the grabbed file
            if [ "$files" = "$file" ]; then files=""
            else files="${files}"; fi

            # trash the file
            trash-put "$(basename "$file")"
        done
    }}'';

    # there is an extraction function in home/zsh/function/extract.sh
    # but we must define our own because lf subshell doesnt run zshrc
    custom_extract = /*sh*/ ''%{{
        if [ -f "$f" ] ; then
            case "$f" in
                *.tar.bz2)   tar xjf    "$f" ;;
                *.tar.gz)    tar xzf    "$f" ;;
                *.tar.xz)    tar xJf   "$f" ;;
                *.bz2)       bunzip2    "$f" ;;
                *.rar)       unrar x    "$f" ;;
                *.gz)        gunzip     "$f" ;;
                *.tar)       tar xf     "$f" ;;
                *.tbz2)      tar xjf    "$f" ;;
                *.tgz)       tar xzf    "$f" ;;
                *.zip|*.xpi) unzip      "$f" ;;
                *.Z)         uncompress "$f" ;;
                *.7z)        7z x       "$f" ;;
                *) echo "'$f' cannot be extracted via custom_extract()" ;;
            esac
        else
            echo "'$f' is not a valid file"
        fi
    }}'';
}
