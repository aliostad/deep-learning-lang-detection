var Modal = (function() {

    var overlay = $(".overlay");

    overlay.addEventListener('webkitTransitionEnd', function(e) {
        if (!this.classList.contains('show')) {
            overlay.classList.add("hide");
        }
    }, false);

    function _showOverlay() {
        overlay.classList.remove("hide");
        overlay.classList.add("show");
    }

    function _hideOverlay() {
        overlay.classList.remove("show");
    }

    function show(sel) {
        _showOverlay();
        $(sel).classList.add("show");
    }

    function hide(sel) {
        _hideOverlay();
        $(sel).classList.remove("show");
    }

    return {
        show: show,
        hide: hide
    };

})();