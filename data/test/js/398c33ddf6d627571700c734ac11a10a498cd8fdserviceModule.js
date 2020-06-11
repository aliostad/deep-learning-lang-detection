var serviceModule = (function() {
    var s;

    function serviceShow() {
        s.serviceContainer.show(1);
        s.serviceBelt.css('left', '-100%');
    }

    function serviceHide() {
        s.serviceBelt.css('left', '0%');
        s.serviceContainer.hide(2000);
    }

    function scrollToTop() {
        $('html, body').animate({
            scrollTop: s.serviceSection.offset().top
        }, s.scrollToTopSpeed);
    }

    function loadService(target) {
        var target = $(target).attr('href');
        s.serviceContainer.load(target);
    }

    function bindUIactions() {
        s.serviceLink.on('click', function(event) {
            event.preventDefault();
            loadService(event.target);
            serviceShow();
            scrollToTop();
        });
        s.serviceContainer.on('click', function() {
            serviceHide();
        });
    }

    return {
        settings: {
            serviceSection: $('.service'),
            serviceContainer: $('.service-container'),
            serviceBelt: $('.service-belt'),
            serviceLink: $('.service-link'),
            serviceClose: $('.service-close'),
            scrollToTopSpeed: 10
        },

        init: function() {
            s = this.settings;
            bindUIactions();
        }
    }
})();