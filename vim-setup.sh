#!/bin/bash

# print welcome message
echo "vim setup has been started"


# determine OS
OS=$(uname)

if [[ ${OS} != "Darwin" && ${OS} != "Linux" ]]; then
    echo "${OS} is not supported"
    exit 1
fi


# check if git is installed
echo -ne "checking for git... "

GIT=$(which git)

if [ -z ${GIT} ]; then
    echo "no"
    exit 1
else
    echo "found"
fi


# check if hg is installed
echo -ne "checking for hg... "

HG=$(which hg)

if [ -z ${HG} ]; then
    echo "no"
    exit 1
else
    echo "found"
fi

# creating folder for vim
echo "creating directory for vim $HOME/.vim"
