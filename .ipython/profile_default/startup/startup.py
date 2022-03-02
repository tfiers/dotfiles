
print(f"Running {__file__}")

# If the last executed expression was an assignment, print the assigned value, instead
# of nothing. This obviates the need to retype the variable name, as in `myprod=3*7;
# myprod`. Output prints can still be suppressed by ending the line with `;`.
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "last_expr_or_assign"

# If you get 'black' autoformatting (https://github.com/ipython/ipython/pull/13464),
# upgrade IPython (it's disabled again in 8.1): open an elevated prompt, run `condini`
# (to activate base; see `~/.bashrc`), and run `pip install -U ipython`.

import sys, os, re, shutil, pathlib, math, random, \
       itertools, functools, collections, datetime    # (Using braces not allowed here).
#
from time import time
from pathlib import Path
from functools import partial
from collections import defaultdict
#
# `OrderedDict` is not necessary anymore since Python 3.7: iterating over a plain `dict`
# is now guaranteed to yield items in insertion order. Differences between the two:
# https://realpython.com/python-ordereddict/#selecting-the-right-dictionary-for-the-job
#
print("Imported some stdlib functions and namespaces.")
