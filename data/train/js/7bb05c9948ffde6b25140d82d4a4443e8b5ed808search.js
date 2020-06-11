
function show_content(level) {

if (level == "bachelor" || level == "master")
    $("#show_when_BM1").show();

if (level == "bachelor")
{    
    $("#show_when_B").show();
    $("#show_when_M").hide();
}

if (level == "master")
{    
    $("#show_when_M").show();
    $("#show_when_B").hide();
}
if (level == "bachelor" || level == "master")
    $("#show_when_BM2").show();


/*

document.getElementById(d).style.display = "block";
is gelijk aan:
$("show_when_BM1").show();
*/
}


function show_addcourses(profile) 
{
    if (profile == "CM")
    {
        $("#show_when_CM").show()
        $("#show_when_EM").hide()
        $("#show_when_NG").hide()
        $("#show_when_NT").hide()
    }
    
    if (profile == "EM")
    {
        $("#show_when_CM").hide()
        $("#show_when_EM").show()
        $("#show_when_NG").hide()
        $("#show_when_NT").hide()
    }
    
    if (profile == "NG")
    {
        $("#show_when_CM").hide()
        $("#show_when_EM").hide()
        $("#show_when_NG").show()
        $("#show_when_NT").hide()
    }
    
    if (profile == "NT")
    {
        $("#show_when_CM").hide()
        $("#show_when_EM").hide()
        $("#show_when_NG").hide()
        $("#show_when_NT").show()
    }
    
}


/*
 * 
 $function() 
{
    $('#search_button').on('click', function(e) 
    {
        var program = 
        {
            level_b: $('level_bachelor').val(),
            level_m: $('level_master').val()
        };
        
        // send to server
        $.post('controller/search', function(response) 
        {
            response = JSON.parse(response);
            
            // display    
            if(response.succes) 
            {
                $('#result_list').prepend(program.level_b program.level_m).listview('refresh');
            }
        }
    }
}*/
