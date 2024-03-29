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
flameshot \
htop \
gcc-c++ \
clang \
snapd \

! sudo ln -s /var/lib/snapd/snap /snap

SNAP_BIN=/var/lib/snapd/snap/bin

#brew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
BREW_BIN=/home/linuxbrew/.linuxbrew/bin


#fish plugin
#curl -L https://get.oh-my.fish | fish
#omf install bobthefish


#pm flameshot config (enable text)

#add best terminal emulator
sudo dnf copr enable -y pschyska/alacritty
sudo dnf install -y alacritty

#init I3/sway
sudo dnf install -y \
sway \
swaylock \
rofi \

#minimal sway config
! mkdir ~/.config/sway
cp ./dotfiles/sway/config ~/.config/sway/config
swaymsg reload

#F31 fix: downgrade to cgroup v1
sudo dnf install -y grubby
sudo grubby  --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"


#minikube
sudo dnf install -y \
ridge-utils  \
libvirt \
virt-install \
qemu-kvm \
virt-manager \

sudo systemctl enable libvirtd

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
&& chmod +x minikube

! sudo cp minikube /usr/local/bin
rm minikube

NPROC=$(nproc)
let minikube_cpus=NPROC/2         

minikube config set cpus $minikube_cpus 


let NRAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')/1024
let minikube_ram=NRAM/2
minikube config set memory $minikube_ram 

minikube config set disk-siz 90000MB
minikube config set vm-driver kvm2

sudo usermod --append --groups libvirt $(whoami)

#kubernetes tools

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh 

#clean dotfile
! rm ~/.profile
! rm ~/.config/fish/config.fish

#init go
! mkdir -p $HOME/go
echo "export GOPATH=$HOME/go" >> $HOME/.profile

#init rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
RUST_BIN="$HOME/.cargo/bin"

#init github
#lpass login $1
#lpass show worstation-github  --field "Public Key" > ~/.ssh/workstation-github.pub
#chmod 644 ~/.ssh/workstation-github.pub
#lpass show worstation-github  --field "Private Key" > ~/.ssh/workstation-github
#chmod 600 ~/.ssh/workstation-github

#gitkraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
sudo dnf install -y ./gitkraken-amd64.rpm
rm ./gitkraken-amd64.rpm

#IDE
##IDEA
! mkdir ~/jetbrains-toolbox
export JB_TOOLBOX_VERSION=1.16.6016
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-$JB_TOOLBOX_VERSION.tar.gz
tar -xvzf ./jetbrains-toolbox-$JB_TOOLBOX_VERSION.tar.gz
! cp ./jetbrains-toolbox-$JB_TOOLBOX_VERSION/jetbrains-toolbox ~/jetbrains-toolbox
rm -Rf ./jetbrains-toolbox-$JB_TOOLBOX_VERSION
rm ./jetbrains-toolbox-$JB_TOOLBOX_VERSION.tar.gz
##CODE
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf -y check-update
sudo dnf -y install code


#update PATH

echo "export PATH=$PATH:$RUST_BIN:$SNAP_BIN:$HOME/jetbrains-toolbox:$BREW_BIN" >> $HOME/.profile
. ~/.profile

echo "set -gx PATH $PATH $RUST_BIN $SNAP_BIN $HOME/jetbrains-toolbox $BREW_BIN" >> $HOME/.config/fish/config.fish

#git config
git config --global alias.cof $'!git for-each-ref --format=\''%\(refname:short\)\'' refs/heads | fzf | xargs git checkout'


#post install action
rustup update


#clean
history -c

echo "Bootstrap Done"
