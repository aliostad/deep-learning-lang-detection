/**
 * Code for toggling version metadata.
 */
AJS.toInit(function ($) {
    var comment = $("#version-comment");
    if (comment.length) {
        var showLink = $("#show-version-comment");
        var hideLink = $("#hide-version-comment");
        showLink.click(function (e) {
            showLink.hide();
            hideLink.show();
            comment.show();
            return AJS.stopEvent(e);
        });
        hideLink.click(function (e) {
            hideLink.hide();
            showLink.show();
            comment.hide();
            return AJS.stopEvent(e);
        });
    }
});
