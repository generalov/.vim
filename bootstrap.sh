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

# Python
git clone git://github.com/kevinw/pyflakes-vim.git bundle/pyflakes-vim
git clone git://github.com/fs111/pydoc.vim.git bundle/pydoc
git clone git://github.com/vim-scripts/pep8.git bundle/pep8
#git clone git://github.com/generalov/pytest.vim.git bundle/managepy.test
git clone git://github.com/alfredodeza/pytest.vim.git bundle/pytest.vim

git clone git://github.com/reinh/vim-makegreen bundle/makegreen
git clone git://github.com/vim-scripts/TaskList.vim.git bundle/tasklist
#git clone git://github.com/kablamo/VimDebug.git bundle/vimdebug

# Math
git clone git://github.com/gregsexton/VimCalc.git bundle/vimcalc

# Formats
git clone git://github.com/davidoc/taskpaper.vim.git bundle/taskpaper
git clone git://github.com/tpope/vim-markdown.git bundle/vim-markdown


sed -i 's#git@github.com:kevinw/pyflakes.git#git://github.com/kevinw/pyflakes.git#g' bundle/pyflakes-vim/.git/config
sed -i 's#git@github.com:kevinw/pyflakes.git#git://github.com/kevinw/pyflakes.git#g' bundle/pyflakes-vim/.gitmodules

ls bundle | while read line; do
(
    cd bundle/$line
    git submodule init
    git submodule update
)
done

patch -d bundle/pyflakes-vim -p1 <<EOD
--- a/ftplugin/python/pyflakes.vim
+++ b/ftplugin/python/pyflakes.vim
@@ -47,7 +47,10 @@ scriptdir = os.path.join(os.path.dirname(vim.eval('expand("<sfile>")')), 'pyflak
 if scriptdir not in sys.path:
     sys.path.insert(0, scriptdir)
 
-import ast
+try:
+    import ast
+except ImportError:
+    import _ast as ast
 from pyflakes import checker, messages
 from operator import attrgetter
 import re
@@ -68,7 +71,7 @@ class blackhole(object):
 
 def check(buffer):
     filename = buffer.name
-    contents = buffer[:]
+    contents = list(buffer)[:]
 
     # shebang usually found at the top of the file, followed by source code encoding marker.
     # assume everything else that follows is encoded in the encoding.
@@ -96,7 +99,7 @@ def check(buffer):
         # TODO: use warnings filters instead of ignoring stderr
         old_stderr, sys.stderr = sys.stderr, blackhole()
         try:
-            tree = ast.parse(contents, filename or '<unknown>')
+            tree = compile(contents, filename or '<unknown>', 'exec', ast.PyCF_ONLY_AST)
         finally:
             sys.stderr = old_stderr
     except:
EOD
