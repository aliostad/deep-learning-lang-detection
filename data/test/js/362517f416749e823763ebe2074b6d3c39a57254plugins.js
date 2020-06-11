
(function($){

    var widgets = {

        jQuery : $,

        options: {
            show_draggable: true,
            show_collapsable: true,
            show_killable: true,
            show_settings: true,
            show_properties: true
        },

        state: {
          user: {},
          resource: {}
        },

        _create: function () {
            alert ( 'create' ) ;
        },

        serialize: function () {

        }

    } ;

    $.widget( ".widget", widgets );


    alert ( 'z' ) ;

})(jQuery);

alert ( 'a' ) ;
