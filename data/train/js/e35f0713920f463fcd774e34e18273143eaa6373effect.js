// Rating
function initRating() {
    $('.rating').raty({
        hintList: ['', '', '', '', ''],
        half: true,
        start: score,
        click: raty_click
    });
}

// Message
function hideMessage() {
    messageHeight = $('.message').outerHeight(); // fill array
    $('.message').css('bottom', -messageHeight); //move element outside viewport
}

function showMessage(type, message) {
    m = $('.message');
    hideMessage();
    m.addClass(type).html(message);
    messageHeight = m.outerHeight();
    console.log(messageHeight);
    m.animate({bottom:"0"}, 500).delay(5000).animate({bottom: -messageHeight}, 500, function () {
        m.attr('class', 'message');
    });
}

$(document).ready(function() {
    // Initially, hide the message
    hideMessage();

    // Show rating
    initRating();
});
