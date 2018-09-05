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
    if [ -f "$cachefile" ];then
        old=$(<$cachefile)
    else
        old=""
    fi
    #su -c 'for i in $(ls /data/data); do if [[ ! "$(dumpsys package $i | grep system)" ]]; then echo $i;fi;done'  > $cachefile
    su -c 'for i in $(ls /data/data); do  echo $i;done'  > $cachefile
    fixterm
    new=$(<$cachefile)
    # Will only produce output if the full versions of grep and diffutils is installed
    diff <(echo "$old") <(echo "$new") | grep "<\|>" ||:
}

fixterm(){
#Some of the root commands cause weird shell glitches
stty sane 2>/dev/null ||:
return
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
            app=`cat $cachefile | fzf -f "$pattern"|head -n 1`
        fi
        if [ -n "$app" ];then
            echo "Opening $app"
            # monkey messes with the rotation setting in android (why?), so we save it beforehand and restore it afterwards
            # This currently has a bug; if the user has locked the rotation to landscape running app will
            # Switch the rotation to portrait
            accelerometer_rotation=`su -c settings get system accelerometer_rotation`
            su -c monkey -p $app -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
            su -c settings put system accelerometer_rotation $accelerometer_rotation
fixterm
        else
            exit 1
        fi
    else
        echo "App cache is empty. Run \`$name -u\`."
    fi
fi
