(function($) {
    $.fn.messageBox = function() {
        var $this = $(this);

        function showMessage(message, color) {
            var messageDiv = $('<div>')
                .text(message)
                .css('color', color)
                .css('font-size', '200%')
                .fadeIn(1000, 'linear');
            $this.append(messageDiv);

            setInterval(function() {
                messageDiv.remove();
            }, 3000);
        }

        return {
            success: function(message) {
                showMessage(message, 'green');
            },
            error: function(message) {
                showMessage(message, 'red');
            }
        };
    };
}(jQuery));
