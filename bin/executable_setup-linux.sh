#! /bin/bash

# script to run with a wget that can provision a box.
cd ~
echo "installing essentials"
sudo apt-get install build-essential screen tmux vim-gtk python ruby git screen

echo "setting up dotfiles"
cd ~
git clone https://raghur@bitbucket.org/raghur/home.git
mv home/.git ~
rm -rf ~/home
git reset --hard HEAD

echo "Setting up vim config"
cd ~
git clone https://raghur@github.com/raghur/vimfiles.git
cd vimfiles && git submodule init && git submodule update
cd ~
echo "Copying powerline font to sys font dir"
sudo cp ~/vimfiles/consolas-Powerline.otf /usr/share/fonts/truetype/freefont/

echo "Configure fonts"
sudo cp ~/vimfiles/consolas-Powerline.otf /usr/share/fonts/truetype

echo "configuring dependencies for VimRepress"
sudo apt-get install python-setuptools
easy_install markdown

echo "Setting up emacs"
cd ~
git clone https://raghur@github.com/raghur/emacs.d.git .emacs.d


echo << END
A lot of changes made to the config files
can take effect only if you log out and log in.
END





