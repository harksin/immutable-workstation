#! /bin/sh 

if [ $# -eq 0 ]
  then
    echo "No lasstpass account supplied"
    exit 1
fi

sudo dnf update -y
sudo dnf install -y neovim nano httpie lastpass-cli git


#init github
lpass login $1
lpass show worstation-github  --field "Public Key" > ~/.ssh/workstation-github.pub
chmod 644 ~/.ssh/workstation-github.pub
lpass show worstation-github  --field "Private Key" > ~/.ssh/workstation-github
chmod 600 ~/.ssh/workstation-github
