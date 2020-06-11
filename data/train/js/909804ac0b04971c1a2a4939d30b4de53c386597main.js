/**
 * Author: Murad Gasanov.
 */
(function ($) {
    $(function() {
        var App = (function(){

            function show_nii() {
                $(".tree.section").slideUp();
                $(".nii.section").slideDown();
                $(".show_tree").removeClass("active");
                $(".show_nii").addClass("active");
            }
            function show_tree() {
                $(".tree.section").slideDown();
                $(".nii.section").slideUp();
                $(".show_tree").addClass("active");
                $(".show_nii").removeClass("active");
            }

            $(window).on("show_nii", show_nii);
            $(window).on("show_tree", show_tree);
            $(".show_tree").click(show_tree);
            $(".show_nii").click(show_nii);

            return {
                init: function(){
                    Project_tree.run();
                    Nii.run();
                }
            }
        })();

        App.init();

    })
})(jQuery);