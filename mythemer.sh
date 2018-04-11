#!/bin/bash
I3_DIR=$HOME/.config/i3
POLYBAR_DIR=$HOME/.config/polybar
COMPTON_DIR=$HOME/.config
MY_THEMER_DIR=$HOME/.config/mythemer
THEMES_DIR=$MY_THEMER_DIR/themes

function usage {
    echo "Usage: mythemer <list|set>"
    exit 1
}

function usage_set {
    echo "Usage: mythemer set <theme>"
    exit 1
}

function themes_list {
    list=$(find $THEMES_DIR/* -maxdepth 1 -type d -printf "%f ")
    for l in $list; do
        echo $l
    done
}

function link_files {
    THEME_NAME=$1
    files=$(find $THEMES_DIR/$THEME_NAME/* -type f -printf "%f ")
    #files="i3 polybar compton wallpaper.jpg"

    # Create an associative array to store which command to execute for every file
    declare -A LINK_PATHS
    LINK_PATHS[polybar]="ln -sf $THEMES_DIR/$THEME_NAME/polybar $POLYBAR_DIR/config"
    LINK_PATHS[i3]="ln -sf $THEMES_DIR/$THEME_NAME/i3 $I3_DIR/config"
    LINK_PATHS[compton]="ln -sf $THEMES_DIR/$THEME_NAME/compton $COMPTON_DIR/compton.conf"
    LINK_PATHS[wallpaper.jpg]="nitrogen --set-scaled $THEMES_DIR/$THEME_NAME/wallpaper.jpg"
    LINK_PATHS[wallpaper.png]="nitrogen --set-scaled $THEMES_DIR/$THEME_NAME/wallpaper.png"

    for f in $files; do
        echo "${LINK_PATHS[${f}]}"
        bash -c "${LINK_PATHS[${f}]}"
    done
}

function set_theme {
    THEME_NAME=$1
    list=$(themes_list)
    if [ -d $THEMES_DIR/$THEME_NAME ]; then
        link_files $THEME_NAME
        i3-msg reload
        i3-msg restart
        echo "$THEME_NAME setted"
    else
        echo "cannot find $THEME_NAME"
    fi
}

#####
##### Main
#####

if (( $# < 1 )); then
    usage
fi

case $1 in
    list|l)
        themes_list;;
    set|s)
        if (( $# < 2 )); then
            usage_set
        fi
        set_theme $2;;
    *)
        usage
        break;;
esac
