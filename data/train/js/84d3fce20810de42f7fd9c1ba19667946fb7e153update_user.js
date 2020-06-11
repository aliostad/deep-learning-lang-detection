$(document).ready(function() {
    var username;
    $('#show_button').hide();
    $('#show_messsage').hide();
    
    var complete = function(){
        $("#show_messsage").fadeOut(2600, function(){$('#edit_username').show();});            
    }
    
    $('#edit_username').click(function() {
        console.log('Handler for .click() called.');
        username = $('#show_username').text(); 
        var show_html = '<input type="text" name="username" id="username" value="'+username+'" />';
        $('#show_username').html(show_html);
        $('#show_button').show();
        $(this).hide();
    });
    
    $('#save_username').click(function() {
        username = $('#username').val();
        $('#show_button').hide();
        $('#username').attr("disabled", true);
        console.log(username);
        $.ajax({
            type: "POST",
            url: "/auth/change_username",
            data: {
                "username": username,
            },
            success: function(result){
                var show_html = username;
                $('#show_username').html(show_html);
                $('#show_messsage').fadeIn("slow", complete);
            }
        }); //end ajax call   
    });

    $('#cancel').click(function() {
        $('#show_button').hide();
        $('#edit_username').show();
        var show_html = username;
        $('#show_username').html(show_html);
    });
});