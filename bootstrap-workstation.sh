#! /bin/sh 

#if [ $# -eq 0 ]
#  then
#    echo "No lasstpass account supplied"
#    exit 1
#fi

sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --set-enabled google-chrome -y

sudo dnf update -y
sudo dnf install -y \
neovim \
nano \
httpie \
lastpass-cli \
git \
google-chrome-stable \
golang \
java-11-openjdk.x86_64 \
bat \
ripgrep \
fzf \
fish \

#clean dotfile
! rm ~/.profile

#init go
! mkdir -p $HOME/go
echo 'export GOPATH=$HOME/go' >> $HOME/.profile

#init rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
echo 'export PATH=$PATH:$HOME/.cargo/bin' >> $HOME/.profile
. ~/.profile
#todo fish conf
rustup update

#init github
#lpass login $1
#lpass show worstation-github  --field "Public Key" > ~/.ssh/workstation-github.pub
#chmod 644 ~/.ssh/workstation-github.pub
#lpass show worstation-github  --field "Private Key" > ~/.ssh/workstation-github
#chmod 600 ~/.ssh/workstation-github


#IDE
export JB_TOOLBOX_VERSION=1.16.6016
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-$JB_TOOLBOX_VERSION.tar.gz
tar -xvzf ./jetbrains-toolbox-$JB_TOOLBOX_VERSION.tar.gz
./jetbrains-toolbox-$JB_TOOLBOX_VERSION/jetbrains-toolbox
rm -Rf ./jetbrains-toolbox-$JB_TOOLBOX_VERSION

#git config
git config --global alias.cof $'!git for-each-ref --format=\''%\(refname:short\)\'' refs/heads | fzf | xargs git checkout'

#clean
history -c

echo "Bootstrap Done"
