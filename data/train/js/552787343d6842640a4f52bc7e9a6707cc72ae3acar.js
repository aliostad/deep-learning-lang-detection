$(document).ready(function () {
    if ($("#rental").val() == "2") {
        //alert(clicker);
        $('#quantity').show();
        $('#TextBox1').hide();
        $('#days').show();
        $('#kml').hide();
        $('#kmlab').text = ("Kilometers*");
    }
    else if ($("#rental").val() == "3") {
        $('#quantity').hide();
        $('#TextBox1').show();
        $('#days').hide();
        $('#kml').show();
        $('#kmlab').text = ("Kilometers per day*");
    }
    else {
        $('#quantity').show();
        $('#TextBox1').show();
        $('#days').show();
        $('#kml').show();
        $('#kmlab').text = ("Kilometers*");
    }


});