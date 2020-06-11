 $(function(){
     $('.first').css('opacity','1');
            $(".second_show").hide();
            $(".third_show").hide();
            	$('.second').css('opacity','0.5');
                $('.third').css('opacity','0.5');
            

            $('.first').click(function(e){
                $('.first_show').show();
                    $(".second_show").hide();
                    $(".third_show").hide();                
                       	$('.first').css('opacity','1');
                        $('.second').css('opacity','0.5');
                        $('.third').css('opacity','0.5');                        
                 			e.preventDefault();
            });

            $('.second').click(function(e){
                $('.second_show').show();
                    $(".third_show").hide();              
                    $('.first_show').hide();
                    	$('.second').css('opacity','1');
                        $('.first').css('opacity','0.5');
                        $('.third').css('opacity','0.5');                        
                 		e.preventDefault();
            });
             $('.third').click(function(e){
                $('.third_show').show();              
                    $('.first_show').hide();
                    $(".second_show").hide();
                    	$('.third').css('opacity','1');
                        $('.first').css('opacity','0.5');
                        $('.second').css('opacity','0.5');                        
                 		e.preventDefault(); 

    		});

});