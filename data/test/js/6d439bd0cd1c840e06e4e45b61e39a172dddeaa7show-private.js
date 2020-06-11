(function() {
    var showText = 'show private';
    var hideText = 'hide private';
    var $showPrivate = $('#show-private');
    $showPrivate.on('click', function(e) {
        e.preventDefault();
        $('.is-private').toggleClass('hidden');
        $('[data-spy="scroll"]').each(function() {
            $(this).scrollspy('refresh')
        });
        if ($showPrivate.text() === hideText) {
            $showPrivate.text(showText);
        } else {
            $showPrivate.text(hideText);
        }
    });
}());
