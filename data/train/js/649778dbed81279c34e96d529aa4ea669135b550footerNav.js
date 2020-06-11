(function (ns, $) {

    'use strict';

    function FooterNav() {
        FooterNav.self = this;
    }

    FooterNav.prototype.init = function () {
        //$('#footerNav').load('../IMT_includes/common.html #footerNav', function () {
            $('#footerNav .footer-btn-tools').on('click', function (e) {
//                $('#footerNav').trigger('create');
                $(FooterNav.self).trigger('footerBtnClicked', [e.target.id]);
            });

            $(FooterNav.self).trigger('loaded');

        //});
    };


    // Export to window
    ns.FooterNav = FooterNav;
})(window.IMT_Numbercards = window.IMT_Numbercards || {}, jQuery);
