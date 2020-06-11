/**
 * Created by alex on 29.04.15.
 */
// flash message
var showedMessage = 0;
var countMessage = $('.flash-message').length;
var currentMessage;
var currentHeight;

$('.flash-message').on('click', function(event){
    $(this).stop().slideUp();
    event.preventDefault();
});

function showMessage(index) {
    currentMessage = $('.flash-message').eq(index);
    setTimeout(function(){
        currentMessage.slideDown(function() {
            currentHeight = $(this).height();
            if(++showedMessage < countMessage) {
                showMessage(showedMessage);
            } else {
                showedMessage = 0;
                setTimeout(function() {
                    hideMessage(showedMessage);
                }, 3000);
            }
        });
    }, 500);
}
function hideMessage(index) {
    currentMessage = $('.flash-message').eq(index);
    currentMessage.slideUp(function(){
        if(++showedMessage < countMessage) {
            setTimeout(function(){
                hideMessage(showedMessage);
            }, 2000);
        }
    });
}

showMessage(showedMessage);