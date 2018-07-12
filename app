#!/data/data/com.termux/files/usr/bin/bash
show_help(){
    printf "Launch Android Apps from Termux

    Syntax:
    $name [OPTION ] [PATTERN]
    Options:
    -u update app cache
    "
}

update_cache(){
    su -c 'for i in $(ls /data/data); do if [[ ! "$(dumpsys package $i | grep system)" ]]; then echo $i;fi;done'  > $cachefile
}

name=$(basename $0)
OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize our own variables
update=false
cachefile="$HOME/.local/share/termux-launcher-app-cache"
while getopts "h?u" opt; do
    case "$opt" in
        h|\?)
            show_help
            exit 0
            ;;
        u)  update=true
            ;;
    esac
done

shift $((OPTIND-1))

pattern=$1

if $update;then
    update_cache
else
    if [ -f "$cachefile" ];then
        if [ -z "$pattern" ];then
            app=`cat $cachefile | fzf`
        else
            app=`cat $cachefile | fzf -f "$pattern"`
        fi
        if [ -n "$app" ];then
            su -c monkey -p $app -c android.intent.category.LAUNCHER 1
        else
            exit 1
        fi
    else
        echo "App cache is empty. Run \`$name -u\`."
    fi
fi

