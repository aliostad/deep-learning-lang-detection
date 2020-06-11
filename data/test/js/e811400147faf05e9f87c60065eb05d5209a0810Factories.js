var MobileNavTransitions = (function () {
    function MobileNavTransitions(value) {
        this.value = value;
    }
    MobileNavTransitions.prototype.toString = function () {
        return this.value;
    };

    MobileNavTransitions.slide = new MobileNavTransitions("slide");
    MobileNavTransitions.modal = new MobileNavTransitions("modal");
    MobileNavTransitions.none = new MobileNavTransitions("none");
    return MobileNavTransitions;
})();

var PageNavFactory = (function () {
    function PageNavFactory($navigate) {
        this.$navigate = $navigate;
    }
    PageNavFactory.prototype.slidePage = function (path, transition) {
        this.$navigate.go(path, transition.toString());
    };

    PageNavFactory.prototype.back = function () {
        this.$navigate.back();
    };
    return PageNavFactory;
})();
