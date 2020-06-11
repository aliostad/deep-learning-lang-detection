$("document").ready(function() {
                $('#navType').click(function(){
                    $('html, body').animate({
                        scrollTop: $("#typography").offset().top -60
                    }, 1500);
                
                 });
                 $('#navButtons').click(function(){
                    $('html, body').animate({
                        scrollTop: $("#buttons").offset().top -60
                    }, 1500);
                
                 });
                 $('#navInputs').click(function(){
                    $('html, body').animate({
                        scrollTop: $("#inputs").offset().top -60
                    }, 1500);
                
                 });
                 $('#navImages').click(function(){
                    $('html, body').animate({
                        scrollTop: $("#imagery").offset().top -40
                    }, 1500);
                
                 });


                 $('#navType').on('click',function(){
                 	$('#navType').addClass('underlined');
                 	$('#navButtons').removeClass('underlined');
                 	$('#navInputs').removeClass('underlined');
                 	$('#navImages').removeClass('underlined');

                 });

                 $('#navButtons').on('click',function(){
                 	$('#navButtons').addClass('underlined');
                 	$('#navType').removeClass('underlined');
                 	$('#navInputs').removeClass('underlined');
                 	$('#navImages').removeClass('underlined');

                 });
                 $('#navInputs').on('click',function(){
                 	$('#navInputs').addClass('underlined');
                 	$('#navType').removeClass('underlined');
                 	$('#navButtons').removeClass('underlined');
                 	$('#navImages').removeClass('underlined');

                 });
                 $('#navImages').on('click',function(){
                 	$('#navImages').addClass('underlined');
                 	$('#navType').removeClass('underlined');
                 	$('#navInputs').removeClass('underlined');
                 	$('#navButtons').removeClass('underlined');

                 });


 });