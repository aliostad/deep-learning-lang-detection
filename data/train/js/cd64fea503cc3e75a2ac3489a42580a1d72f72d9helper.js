//TODDO: Use bootbox.js dialogs here
function showMessage(message, title) {
    $('<div id="messagePopup"></div>').append('<div id="messageDiv">' + message + '</div>').dialog( {
        dialogClass: "error",
        show: {duration: 200},
        height: 250,
        width: 600,
        modal: true,
        resizable: false,
        title: title,
        buttons: [ {
            id: "messagePopupOkButton",
            text: "Ok",
            click: function() {
                $('#messagePopup').dialog('close');
                $('#messagePopup').remove();
                $(this).dialog("destroy").remove();
            }
        } ]
    });
}

function showErrorMessage(errorMessage) {
    showMessage(errorMessage, 'Error');
}

function showSuccessMessage(message) {
    showMessage(message, 'Success');
}