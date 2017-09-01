###
cd "$(dirname "$0")"
pm_i() { pacman -Sy $ins }
pm_db() { pacman -Syy }
pm_u() { pacman -Syu }
echo "START $0"
echo "INSTALLING ZSH"
    ins="zsh zsh-completions" && pm_i
    chsh -s /usr/bin/zsh
    cp -aT /etc/skel/ /root/
    chmod 700 /root
    ins="git" && pm_i
echo "INSTALLING OH_MY_ZSH"
    #powerline powerline-fonts oh-my-zsh
    #sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "INSTALLING DEP POWERLINE "
    ins="powerline powerline-fonts powerline-vim python-powerline" && pm_i
    ins="awesome-terminal-fonts" && pm_i
    ins="fontforge" && pm_i
    # git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    # git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "POWERLINE INSTALL DEP FINALIZED"
    cp -r {.zshrc,.fonts,.oh-my-zsh} ~/
    # cp -r power-themes ~/.oh-my-zsh/custom/themes/
    cp -r fontconfig ~/.config/
    fc-cache -fv ~/.fonts
echo "OH-MY-ZSH INSTALL FINALIZED"
echo "INSTALLING VIM"
    ins="vim vim-plugins" && pm_i
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
echo "VIM INSTALL FINALIZED"
echo "COPYING .zshrc,.oh-my-zsh,.vimrc,.vim_runtime to /etc/skel"
    cp -r ~/{.zshrc,.oh-my-zsh,.vimrc,.vim_runtime} /etc/skel/
    mkdir -p /etc/skel/.config
    cp -r fontconfig /etc/skel/.config/
echo "FINISHED copying all files"
echo "FINIDHED $0"
