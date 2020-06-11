
function show_required_login_plus(){
$('#login-page-wrap').show();
$('.login-status-message').show();
$('.logout-button').show();
$('.addServer-button').show();
$('.addTask-button').show();

$('#tasks').hide();
$('#servers').hide();
$('#addservers').hide();
}

function show_required_login(){
$('#login-page-wrap').show();
$('.login-status-message').hide();
$('.logout-button').hide();
$('.addServer-button').hide();
$('.addTask-button').hide();

$('#tasks').hide();
$('#servers').hide();
$('#addservers').hide();
}

