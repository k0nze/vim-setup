#!/bin/bash

# -r    : remove old files
# -sud  : show ubuntu downloads

#store current dir
DIR=$(pwd)

# remove old setup
if [[ ${1} == "-r" ]]; then
    echo "removing old setup"
    rm -rf $HOME/.opt/vim
    rm -rf $HOME/.opt/ctags
    rm $HOME/.bin/vim
    rm $HOME/.bin/ctags
    rm -rf $HOME/.vim
    rm -rf $HOME/.vimrc.d
    rm $HOME/.vimrc
fi

# show all (Ubuntu) packets which should be installed
if [[ ${1} == "-sud" ]]; then
    echo "sudo apt-get install git mercurial ncurses-dev make curl"
    exit 0
fi

# function which checks if certain programs are installed
function check_prog {
    echo -ne "checking for ${1}... "

    if [[ -z $(which ${1}) ]]; then

        echo "no"
        if [[ ${OS} == "Linux" ]]; then
            echo "try: sudo apt-get install ${2}"
        elif [[ ${OS} == "Darwin" ]]; then
            echo "install XCode developer tools"
        fi

        exit 1
    else
        echo "found"
    fi
}

# print welcome message
echo "vim setup has been started"

# determine OS
OS=$(uname)

if [[ ${OS} != "Darwin" && ${OS} != "Linux" ]]; then
    echo "${OS} is not supported"
    exit 1
fi


# check if git is installed
check_prog git git

# check if hg is installed
check_prog hg mercurial

# check if gcc is installed
check_prog gcc gcc

# check if make is installed
check_prog make make

# check if wget is installed
check_prog wget wget

# check if curl is installed
check_prog curl curl

# check if $HOME/.opt already exists
if [ -e "$HOME/.opt" ]; then
    echo "$HOME/.opt already exists"
else
    mkdir $HOME/.opt
    echo "$HOME/.opt has been created"
fi

# check if $HOME/.bin already exists
if [ -e "$HOME/.bin" ]; then
    echo "$HOME/.bin already exists"
else
    mkdir $HOME/.bin
    echo "$HOME/.bin has been created"
fi

# check if $HOME/.vim already exists
if [ -e "$HOME/.vim" ]; then
    echo "$HOME/.vim already exists"
else
    mkdir $HOME/.vim
    echo "$HOME/.vim has been created"
fi

cd $DIR

# download ctags
echo "downloading ctags source"
cd $HOME
wget "https://github.com/shawncplus/phpcomplete.vim/raw/master/misc/ctags-5.8_better_php_parser.tar.gz" -O ctags-5.8_better_php_parser.tar.gz
tar xvf ctags-5.8_better_php_parser.tar.gz
cd $HOME/ctags

# configure ctags
echo "configure ctags"
./configure --prefix=$HOME/.opt/ctags

# make ctags
echo "make ctags"
make

# make install ctags
echo "make install ctags"
make install

# deleting source files 
echo "deleting ctags source files"
cd $HOME
rm -rf $HOME/ctags
rm -rf $HOME/ctags-5.8_better_php_parser.tar.gz

# creating a symling for ctags bin
echo "creating symlink for ctags bin"
ln -s $HOME/.opt/ctags/bin/ctags $HOME/.bin/ctags

# go back to previous dir
cd $DIR



# downloading vim source
echo "downloading vim"
hg clone https://vim.googlecode.com/hg/ $HOME/vim

# goto vim source dir
cd $HOME/vim/src

# configure vim
echo "configure vim"
./configure --with-features=huge --prefix=$HOME/.opt/vim

# make vim
echo "make vim"
make

# make install vim
echo "make install vim"
make install

# delete source files
echo "deleting vim source files"
rm -rf $HOME/vim

# go back to previous dir
cd $DIR

# creating symlink from .opt/vim/bin/vim to .bin
echo "creating symlink for vim bin"
ln -s $HOME/.opt/vim/bin/vim $HOME/.bin/vim

### .vimrc setup
echo "starting .vimrc setup"

# download .vimrc from github
git clone https://github.com/k0nze/vimrc.git $HOME/.vimrc.d

# symlink for .vimrc
ln -s $HOME/.vimrc.d/.vimrc $HOME/.vimrc

# color scheme
mkdir -p $HOME/.vim/colors
cd $HOME/.vim/colors
wget https://raw.githubusercontent.com/michalbachowski/vim-wombat256mod/master/colors/wombat256mod.vim

# change htmlcomplete.vim
if [[ ${OS} == "Darwin" ]]; then
    sed -i '' 's/toupper(/tolower(/g' $HOME/.opt/vim/share/vim/vim74/autoload/htmlcomplete.vim
else
    sed -i 's/toupper(/tolower(/g' $HOME/.opt/vim/share/vim/vim74/autoload/htmlcomplete.vim
fi

# go to previous dir
cd $DIR

$HOME/.bin/vim +PluginInstall +qall

# echo update $PATH message
echo -e "\e[31myou have to update your PATH!\nPATH=$HOME/.bin:$PATH\e[m"
