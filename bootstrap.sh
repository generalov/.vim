#!/bin/sh

set -e

mkdir -p bundle autoload
wget -O autoload/pathogen.vim --no-check-certificate https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim

# Typing
git clone git://github.com/msanders/snipmate.vim.git bundle/snipmate
git clone git://github.com/tpope/vim-surround.git bundle/surround
git clone git://github.com/ervandew/supertab.git bundle/supertab
git clone git://github.com/tpope/vim-commentary.git bundle/vim-commentary
git clone git://github.com/tpope/vim-repeat.git bundle/vim-repeat

# Git
#git clone git://github.com/tpope/vim-fugitive.git bundle/fugitive
#git clone git://github.com/tpope/vim-git.git bundle/git
git clone git://github.com/laarmen/git-vim.git bundle/git-vim

# Navigation
git clone git://github.com/sontek/rope-vim.git bundle/ropevim
#git clone git://github.com/sontek/minibufexpl.vim.git bundle/minibufexpl
git clone git://github.com/vim-scripts/buftabs.git bundle/buftabs
git clone git://github.com/wincent/Command-T.git bundle/command-t && ( cd bundle/command-t && rake make )
# Graph your Vim undo tree in style.
git clone git://github.com/sjl/gundo.vim.git bundle/gundo # @vim73
# Grep replacement
git clone git://github.com/mileszs/ack.vim.git bundle/ack && which ack-grep || (
    sudo apt-get install ack-grep
)
git clone git://github.com/vim-scripts/The-NERD-tree.git bundle/nerdtree
git clone git://github.com/int3/vim-taglist-plus.git bundle/taglist-plus; which nodejs || (
    #sudo add-apt-repository ppa:richarvey/nodester
    #sudo apt-get update
    #sudo apt-get install nodejs
    #sudo ln -s /usr/bin/nodejs /usr/local/bin/node
    true
)
git clone git://github.com/bogado/file-line.git bundle/file-line

# Python
git clone git://github.com/generalov/pyflakes-vim.git bundle/pyflakes-vim
sed -i 's#git@github.com:kevinw/pyflakes.git#git://github.com/kevinw/pyflakes.git#g' bundle/pyflakes-vim/.git/config
sed -i 's#git@github.com:kevinw/pyflakes.git#git://github.com/kevinw/pyflakes.git#g' bundle/pyflakes-vim/.gitmodules

git clone git://github.com/fs111/pydoc.vim.git bundle/pydoc
git clone git://github.com/vim-scripts/pep8.git bundle/pep8
#git clone git://github.com/generalov/pytest.vim.git bundle/managepy.test
git clone git://github.com/alfredodeza/pytest.vim.git bundle/pytest.vim

git clone git://github.com/reinh/vim-makegreen bundle/makegreen
git clone git://github.com/vim-scripts/TaskList.vim.git bundle/tasklist
#git clone git://github.com/kablamo/VimDebug.git bundle/vimdebug

# JavaScript
# reqires nodejs, rhino or spidermonkey
#git clone git://github.com/othree/jslint.vim.git bundle/jslint
git clone git://github.com/ichernev/jslint.vim.git bundle/jslint

# Math
git clone git://github.com/gregsexton/VimCalc.git bundle/vimcalc

# Formats
git clone git://github.com/davidoc/taskpaper.vim.git bundle/taskpaper
git clone git://github.com/tpope/vim-markdown.git bundle/vim-markdown


ls bundle | while read line; do
(
    cd bundle/$line
    git submodule init
    git submodule update
)
done

