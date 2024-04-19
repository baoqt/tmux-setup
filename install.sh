unzip nvim.zip -d ~/.config
unzip tmux.zip -d ~/.config

YUM=$(which yum)
APT=$(which apt-get)
DNF=$(which dnf)

if [[ ! -z $YUM ]]; then
  sudo yum install make -y
  sudo yum install cmake -y
  sudo yum install tmux -y
elif [[ ! -z $APT ]]; then
  sudo apt-get install make -y  
  sudo apt-get install cmake -y
  sudo apt-get install tmux -y
elif [[ ! -z $DNF ]]; then 
  sudo dnf install make -y
  sudo dnf install cmake -y
  sudo dnf install neovim -y
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

# Set alias for nvim <- vim
read -p "Alias vim as nvim? " USER_IN
case $USER_IN in
  [Yy]* ) echo "Removing existing alias"
          unalias vim 2 > /dev/null
          echo "Creating new alias"
          echo "alias vim=\"nvim\"" >> ~/.bashrc;;
  [Nn]* ) ;;
  * ) ;;
esac
