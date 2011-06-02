#!/bin/sh

set -e

mkdir bundle
(cd autoload; wget -c --no-check-certificate https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim)
git clone git://github.com/tpope/vim-fugitive.git bundle/fugitive
git clone git://github.com/msanders/snipmate.vim.git bundle/snipmate
git clone git://github.com/tpope/vim-surround.git bundle/surround
git clone git://github.com/tpope/vim-git.git bundle/git
git clone git://github.com/ervandew/supertab.git bundle/supertab
git clone git://github.com/sontek/minibufexpl.vim.git bundle/minibufexpl
git clone git://github.com/wincent/Command-T.git bundle/command-t
git clone git://github.com/kevinw/pyflakes-vim.git bundle/pyflakes-vim
git clone git://github.com/mileszs/ack.vim.git bundle/ack
git clone git://github.com/sjl/gundo.vim.git bundle/gundo
git clone git://github.com/fs111/pydoc.vim.git bundle/pydoc
git clone git://github.com/vim-scripts/pep8.git bundle/pep8
git clone git://github.com/alfredodeza/pytest.vim.git bundle/py.test
git clone git://github.com/reinh/vim-makegreen bundle/makegreen
git clone git://github.com/vim-scripts/TaskList.vim.git bundle/tasklist
git clone git://github.com/vim-scripts/The-NERD-tree.git bundle/nerdtree
git clone git://github.com/sontek/rope-vim.git bundle/ropevim
#git clone git://github.com/kablamo/VimDebug.git bundle/vimdebug

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
