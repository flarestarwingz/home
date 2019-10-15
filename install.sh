#!/bin/bash

mainuser=$(whoami)

if (( EUID == 0 )); then
    echo "root or sudo found. Continuing..."
else
    echo "not root - please run with sudo"
    exit 1
fi

sudo apt update 
sudo apt upgrade -y 
sudo apt install vim git zsh powerline byobu -y 
byobu-enable 
sudo chsh -s $(which zsh) 
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo sed -i 's+DSHELL=/bin/bash+DSHELL=/bin/zsh/+' /etc/adduser.conf 
sudo sed -i 's+SHELL=/bin/sh+SHELL=/bin/zsh/+' /etc/default/useradd


sudo cat <<EOF > /etc/skel/.zprofile
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
EOF


sed -i 's+export ZSH="/root/.oh-my-zsh"+export ZSH=\$HOME/.oh-my-zsh+' ~/.zshrc
sed -i 's+ZSH_THEME="robbyrussell"+ZSH_THEME="agnoster"+' ~/.zshrc
sed -i 's+  git+git sudo command-not-found common-aliases systemd+' ~/.zshrc

sudo cp -r .oh-my-zsh /etc/skel/
sudo cp .zshrc /etc/skel

exit 0
