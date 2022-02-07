
// Sort notebooks by name *descending* by default.
// When using ISO-8601-date-prefixed filenames, the newest are then on top.
// See https://github.com/jupyter/notebook/issues/1267#issuecomment-1031481244
function change_order(){
    $("#sort-name").click();  // Default is sort ascending. Click to sort descending.
};
window.setTimeout(change_order, 500); // delay after DOM ready
