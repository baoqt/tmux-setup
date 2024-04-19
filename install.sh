#!/usr/bin/bash
# Set alias for nvim <- vim
read -p "Remove existing nvim / tmux config files? " USER_IN
case $USER_IN in
  [Yy]* ) echo "Removing existing files"
          rm -rf ~/.config/nvim/
          rm -rf ~/.config/tmux;;
  [Nn]* ) ;;
  * ) ;;
esac

unzip nvim.zip -d ~/.config
unzip tmux.zip -d ~/.config

YUM=$(which yum)
APT=$(which apt-get)
DNF=$(which dnf)

if [[ ! -z $YUM ]]; then
  sudo yum install make -y
  sudo yum install cmake -y
  sudo yum install tmux -y
  sudo yum install guake -y
elif [[ ! -z $APT ]]; then
  sudo apt-get install make -y  
  sudo apt-get install cmake -y
  sudo apt-get install tmux -y
  sudo apt-get install guake -y
elif [[ ! -z $DNF ]]; then 
  sudo dnf install make -y
  sudo dnf install cmake -y
  sudo dnf install tmux -y
  sudo dnf install guake -y
else
  echo "Can't determine package manager to install tmux / neovim"
  exit 0
fi

INITIAL=$(git config --global http.sslverify)

git config --global http.sslverify false
git clone https://github.com/neovim/neovim.git
git -C neovim checkout v0.9.5
git config --global http.sslverify ${INITIAL}

cd neovim
sudo rm -r .build
sudo make install
cd ..

mkdir ~/.local/share/fonts
cp SauceCodeProNerdFontMono-Regular.ttf ~/.local/share/fonts/

# Set alias for nvim <- vim
read -p "Alias vim as nvim? " USER_IN
case $USER_IN in
  [Yy]* ) echo "Removing existing alias"
          unalias vim 2>/dev/null
          echo "Creating new alias"
          echo "alias vim=\"nvim\"" >> ~/.bashrc;;
  [Nn]* ) ;;
  * ) ;;
esac

# guake preferences
read -p "Use guake preferences? " USER_IN
case $USER_IN in
  [Yy]* ) echo "Loading guake.conf"
          guake --restore-preferences ./guake.conf;;
  [Nn]* ) ;;
  * ) ;;
esac
