
window.onload = function() {
    window.setTimeout(change_tree_sort_order, 400)
    window.setTimeout(hide_header, 800)
}
// Note: using `$([IPython.events]).on(x, function() {…})` with x =
// "notebook_loaded.Notebook" or "app_initialized.DashboardApp" (all such events:
// https://docs.jupyter.org/en/latest/contributing/ipython-dev-guide/js_events.html)
// does not work. It does work in UserScript weirdly. Also tried using
// `define(['base/js/namespace', 'base/js/events', 'base/js/promises',], function (IPython, events, promises) { … })`
// and `events.on(` or `promises.app_initialized` (from https://github.com/jupyter/notebook/blob/master/notebook/static/custom/custom.js),
// but no dice, very weirdly.

// Sort notebooks by name *descending* by default.
// When using ISO-8601-date-prefixed filenames, the newest are then on top.
// See https://github.com/jupyter/notebook/issues/1267#issuecomment-1031481244
function change_tree_sort_order() {
    $("#sort-name").click()  // Default is sort ascending. Click to sort descending.
}

function hide_header() {
    Jupyter.keyboard_manager.actions._actions["hide_header:toggle"].handler()
    // (Invocation found via looking in the hide-header nbextension src, and exploring the `Jupyter` obj in devtools console).
}

/*
 *   More usefulness:
 *
 *   - To find config and extension dirs: `jupyter --paths`
 *     Extensions are for me eg in C:\ProgramData\jupyter\nbextensions
 *
 *   - Extension dev guide:
 *     https://jupyter-notebook.readthedocs.io/en/stable/extending/frontend_extensions.html
 */
