#!/bin/zsh
###
#cd "$(dirname "$0")"
# source paths.sh
Pm_i() { pacman -Sy $1 }
pm_db() { pacman -Syy }
pm_u() { pacman -Syu }
echo "START $0"
echo "INSTALLING ZSH"
    Pm_i "zsh zsh-completions"
    chsh -s /usr/bin/zsh
    cp -aT /etc/skel/ /root/
    chmod 700 /root
    Pm_i "git wget"
echo "INSTALLING OH_MY_ZSH"
    #powerline powerline-fonts oh-my-zsh
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "INSTALLING DEP POWERLINE "
    Pm_i "powerline powerline-fonts powerline-vim python-powerline"
    Pm_i "awesome-terminal-fonts"
    Pm_i "fontforge"
     git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
     git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "POWERLINE INSTALL DEP FINALIZED"
    # cp -r {.zshrc,.fonts,.oh-my-zsh} ~/
    cp -r $arzsh/power-themes ~/.oh-my-zsh/custom/themes/
    cp -r $arzsh/fontconfig ~/.config/
    # fc-cache -fv ~/.fonts
    cat $arzsh/.zshrc > ~/.zshrc
echo "OH-MY-ZSH INSTALL FINALIZED"
echo "INSTALLING VIM"
    Pm_i "vim vim-plugins"
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime && sh ~/.vim_runtime/install_awesome_vimrc.sh
echo "VIM INSTALL FINALIZED"
echo "COPYING .zshrc,.oh-my-zsh,.vimrc,.vim_runtime to /etc/skel"
    cp -r ~/{.zshrc,.oh-my-zsh,.vimrc,.vim_runtime} /etc/skel/
    mkdir -p /etc/skel/.config
    cp -r $arzsh/fontconfig /etc/skel/.config/
echo "FINISHED copying all files"
echo "FINIDHED $0"
