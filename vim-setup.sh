#!/bin/bash

# -r    : remove old files
# -sud  : show ubuntu downloads

#store current dir
DIR=$(pwd)

# remove old setup
if [[ ${1} == "-r" ]]; then
    echo "removing old setup"
    rm -rf $HOME/.vim
    rm -rf $HOME/.vimrc.d
    rm $HOME/.vimrc
fi

# show all (Ubuntu) packets which should be installed
if [[ ${1} == "-sud" ]]; then
    echo "sudo apt install vim build-essential git cmake libclang clang python python-dev pip"
    echo "sudo pip install nose future mock PyHamcrest webtest"
    exit 0
fi

# function which checks if certain programs are installed
function check_prog {
    echo -ne "checking for ${1}... "

    if [[ -z $(which ${1}) ]]; then

        echo "no"
        if [[ ${OS} == "Linux" ]]; then
            echo "try: sudo apt install ${1}"
        elif [[ ${OS} == "Darwin" ]]; then
            echo "try: brew install ${1}"
        fi

        exit 1
    else
        echo "found"
    fi
}

# function which checks if certain pip modules are installed
function check_pip {
    echo -ne "checking for ${1}... "

    if [[ -z $(pip freeze | grep ${1}) ]]; then

        echo "no"
        echo "try: sudo pip install ${1}"

        exit 1
    else
        echo "found"
    fi
}

# function which checks if certain libraries are installed
function check_lib {
    echo -ne "checking for ${1}... "

    if [[ ${OS} == "Linux" ]]; then
        if [[ -z $(ldconfig -p | grep ${1}) ]]; then
            echo "no"
            echo "try: sudo apt install ${1}"
            exit 1
        fi
    elif [[ ${OS} == "Darwin" ]]; then
        if [[ -z $(mdfind -name ${1}.dylib | grep ${1}) ]]; then
            echo "no"
            echo "try: brew install ${1}"
            exit 1
        fi
    fi

    echo "found"
}


# print welcome message
echo "vim setup has been started"


# determine OS
OS=$(uname)

if [[ ${OS} != "Darwin" && ${OS} != "Linux" ]]; then
    echo "${OS} is not supported"
    exit 1
fi

# check if for installed programs
check_prog git
check_prog wget
check_prog tmux
check_prog cmake
check_prog vim
check_prog clang
check_prog python
check_prog pip
check_pip nose
check_pip future 
check_pip mock 
check_pip PyHamcrest 
check_pip WebTest
check_lib libclang

# check if $HOME/.vim already exists
if [ -e "$HOME/.vim" ]; then
    echo "$HOME/.vim already exists"
    exit 1
else
    mkdir $HOME/.vim
    echo "$HOME/.vim has been created"
fi

cd $DIR

### .vimrc setup
echo "starting .vimrc setup"

# download .vimrc from github
git clone https://github.com/k0nze/vimrc.git $HOME/.vimrc.d

# symlink for .vimrc
ln -s $HOME/.vimrc.d/.vimrc $HOME/.vimrc

# go to previous dir
cd $DIR

# installing vbundle
mkdir -p $HOME/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# compile you complete me and run test
cd $HOME/.vim/bundle/YouCompleteMe
python install.py --clang-completer

cd $HOME/.vim
wget https://raw.githubusercontent.com/Valloric/ycmd/master/.ycm_extra_conf.py

### .tmux.conf setup
echo "starting .tmux.conf setup"

# download .tmux.conf from github
git clone https://github.com/k0nze/tmux_conf.git $HOME/.tmux.conf.d

# symlink for .tmux.conf
ln -s $HOME/.tmux.conf.d/tmux.conf $HOME/.tmux.conf
