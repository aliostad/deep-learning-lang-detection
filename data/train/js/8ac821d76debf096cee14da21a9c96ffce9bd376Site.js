$( document ).ready(function() {
    $('#viewPass').on('change', function () {
        if ($(this).is(':checked')) {
            $('.txtPass').attr('type', 'text');
        }
        else {
            $('.txtPass').attr('type', 'password');
        }
    });

    function showSuccessMessage(_message) {
        prepareMessage();
        $('#alertMessage').addClass('alert-success');
        $('#paragrahpMessage').text(_message);
    }

    function showInfoMessage(_message) {
        prepareMessage();
        $('#alertMessage').addClass('alert-info');
        $('#paragrahpMessage').text(_message);
    }

    function showDangerMessage(_message) {
        prepareMessage();
        $('#alertMessage').addClass('alert-danger');
        $('#paragrahpMessage').text(_message);
    }

    function prepareMessage() {
        $('#alertMessage').removeClass('alert-success').removeClass('alert-danger').removeClass('alert-info');
        $('#alertMessage').removeClass('hideAlert').addClass('showAlert');
    }
});