#!/bin/zsh

Software_menu() {

    # Software_menu
    #
    # TODO: add multimedia_menu
    # TODO: add software menu function
        PS3="$Software_menu_message"
            select Software_menu_options in values back exit
            do
                case_menu_Software main_menu ${Software_menu_options}
            done

}


Buffer_Packages_list() {
    #
    # Buffer_Packages_list
    # TODO: add the Packages_Active_message & Packages_ALL_Active_message & AUR_Packages_Active_message & AUR_Packages_ALL_Active_message to message.sh
    #
    local x=$2; local pre_menu=$1
    for x in $2 ;do
        case $x in
            AUR_*)
                local y=$(echo ${x} | cut -c 5-)
                AUR_Packages_Buffer_list="${AUR_Packages_Buffer_list} ${y}"
                print -P "$CF[99] ${x} ${AUR_Packages_Active_message}"
                    print -P "${AUR_Packages_ALL_Active_message}"
            ;;
            back)
                menu_back ${pre_menu}
            ;;
            exit)
                exit 0
            ;;
            *)
                Packages_Buffer_list="${Packages_Buffer_list} ${x}"
                print -P "$CF[99] ${x} ${Packages_Active_message}"
                print -P "${Packages_ALL_Active_message}"
            ;;
        esac
    done
}

Install_Selected_Packages() {
    # TODO: add Install_Selected_Packages_message to message.sh
    print -P "${Install_Selected_Packages_message}"
    pacman -S ${Packages_Buffer_list}
    Packages_Buffer_list=""
}
AUR_Install_Selected_Packages() {
    # TODO: add AUR_Install_Selected_Packages_message to message.sh
    print -P "${AUR_Install_Selected_Packages_message}"
    print -P "$CF[99] ${Administrator_message} $CF[256]"
    su -l admin -c "yaourt -S ${AUR_Packages_Buffer_list}"
    AUR_Packages_Buffer_list=""
}
Repo_install() {
    local repo=$1
    print -P "$CF[99] adding $repo as a new repo $CF[256]"
    cat $pacc/$repo.repo >> ${pacman_conf}
    pacman -Syy

}
Repo_keyid_add() {
    local keyid=$1
    pacman-key -r ${keyid}
    pacman-key -f ${keyid}
    pacman-key --lsign-key ${keyid}
}
case_menu_Software() {
    #local menuoption=$1; local preview_menu=$2
    # local option_amount=$2; local name=$3; local sublevel=$4 #menu level amnount of times to break to main menu
    preview_menu=$1 ;local menuoption=$2; local case_buffer
    # for menuoption in $menuoption_list; do
        case ${menuoption} in
            PACKAGE_*)
            case_buffer=$(echo ${menuoption} | cut -c 9-) && Buffer_Packages_list ${preview_menu} ${case_buffer}
            ;;
            REPO_*)
            case_buffer=$(echo ${menuoption} | cut -c 6-) && Repo_install ${case_buffer}
            ;;
            KEYID_*)
            case_buffer=$(echo ${menuoption} | cut -c 7-) && Repo_keyid_add ${case_buffer}
            ;;
            back)
            menu_back ${preview_menu}
            ;;
            exit)
            exit 0
            ;;
            *_*)
                menu_valid ${menuoption}
            ;;
            *-*)
                menu_valid ${menuoption}
            ;;
            *)
            menu_invalid ${option_amount}
            ;;
        esac
    # done
}

