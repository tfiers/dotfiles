print(f"Running {__file__}")

# If the last expression of a code cell is eg `product = 3 * 7`, and the cell is run,
# IPython prints nothing, by default. Here, we make it print the result (`21`).
# This avoids having to type an extra line with just `product` to see the result.
# Prints can still be suppressed by ending the line with `;`.
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "last_expr_or_assign"

# If you get 'black' autoformatting (https://github.com/ipython/ipython/pull/13464),
# upgrade IPython: it's disabled again in 8.1. `conda` might not have it yet, so
# use `pip install -U ipython`.

# Import standard lib namespaces; and import some utility functions directly.
#
existing_names = dir() + ["existing_names"]
#
import sys, os, shutil, re, itertools, pdb, math, random, datetime
import functools, pathlib, collections
from functools import partial
from pathlib import Path
from time import time
# from collections import defaultdict  # not necessary since 3.7: use plain `dict`.
#
new_names = [n for n in dir() if n not in set(existing_names)]
    # We don't use set subtraction, as that doesn't preserve order; and python has no
    # OrderedSet. We do use set for fast
#
print("Imported:", ", ".join(new_names))
