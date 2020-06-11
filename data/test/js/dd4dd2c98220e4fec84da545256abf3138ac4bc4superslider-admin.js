jQuery(document).ready(function(){

;(function($) {

   $(".ss_info").tooltip({ 
        track: false,        
        delay: 0,        
        fade: 250,
        left: 10,
        top: -10,
        opacity: 0.7,
        showURL: false,
        extraClass: "superTool",
        //showBody: " - ",
        showURL: false,
        bodyHandler: function() { 
       
            return  $($(this).attr("href")).html(); 
            
        } 
    
    });
    
      $("#show-box .ss-toggler-open").click(function(){
        $("#show-box .ss-show-advanced").slideToggle(1200);
        $(this).hide();
        return false;
      
    });
    
    $("#show-box .ss-toggler-close").click(function(){
        $("#show-box .ss-show-advanced").slideToggle("slow");
        $("#show-box .ss-toggler-open").show();
        return false;
      
    });



})(jQuery);
    
});
    


	

