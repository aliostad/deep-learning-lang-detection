$(function () {
    $('form#perform').on('submit', function (event) {
        $('#ajax-loader').show();

        $.post("/perform", $("#perform").serialize(), function(data) {
            $('#results').prepend(data);

            // Show data according to checkboxes
            if ($('#show_output').is(':checked')) { $('.result').show(); }
            if ($('#show_command').is(':checked')) { $('.command').show(); }
            if ($('#show_response').is(':checked')) { $('.response').show(); }

            $('#results').effect('highlight', 'slow');
            $('#ajax-loader').hide();
        });

        return false;
    });
    $('#show_output').change(function(){
        if ($('#show_output').is(':checked')) {
            $('.result').show();
        } else {
            $('.result').hide();
        }
    });
    $('#show_command').change(function(){
        if ($('#show_command').is(':checked')) {
            $('.command').show();
        } else {
            $('.command').hide();
        }
    });
    $('#show_response').change(function(){
        if ($('#show_response').is(':checked')) {
            $('.response').show();
        } else {
            $('.response').hide();
        }
    });

    $('#clear-log').on('click', function (event) {
        $('#results').html('');
    });
});
