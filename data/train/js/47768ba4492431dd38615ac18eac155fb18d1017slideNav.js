travi.test.testCase('SlideNavTests', (function () {
    'use strict';

    return {
        setUp: function () {
            $('body').append('<nav id="primaryNav"><ul style="display: none">' +
                '<li><ul id="innerList" style="display: none"></ul></li>' +
                '</ul></nav>');

            this.$nav = $('#primaryNav');

            this.$nav.slideNav();
        },

        'test "Navigation" added': function () {
            var $navToggle = this.$nav.find('.navToggle');

            assertEquals(1, $navToggle.length);
            assertEquals('Navigation', $navToggle.text());
            assertEquals(1, $navToggle.find('.ui-icon.ui-icon-triangle-1-s').length);
        },

        'test visibility of menu': function () {
            var $navToggle = this.$nav.find('.navToggle'),
                $list = this.$nav.find('ul');

            assertFalse($list.is(':visible'));

            $navToggle.click();

            assertTrue($list.is(':visible'));

            $navToggle.click();

            assertFalse($list.is(':visible'));
        },

        'test only top level list displayed when menu shown': function () {
            var $innerList = this.$nav.find('#innerList'),
                $navToggle = this.$nav.find('.navToggle');

            $navToggle.click();

            assertFalse($innerList.is(':visible'));
        }
    };
}()));