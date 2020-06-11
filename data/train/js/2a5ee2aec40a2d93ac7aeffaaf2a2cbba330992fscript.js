/* Author:

*/

function msg_error(){
    $('#msg').toggleClass('error');
}


$(function(){
    $('#local_image').show();
    $('#web_image').hide();
    
    var radio = $("input[name='upload_method_2']");
    radio.change(function(){
        $('#local_image, #web_image').toggle();
    });
})




$(function(){
    $('#toggle_exif_on').click(function(){
        $('#toggle_exif_off').show()
        $('#toggle_exif_on').hide()
        $('#exif_exif, #exif_xmp, #exif_photoshop, #exif_iptc, #exif_jfif, #exif_file, #exif_composite, #exif_icc_profile, #exif_exif_tool, #exif_maker_notes').show()
        $('#show_exif_exif, #show_exif_xmp, #show_exif_photoshop, #show_exif_iptc, #show_exif_jfif, #show_exif_file, #show_exif_composite, #show_exif_icc_profile, #show_exif_exif_tool, #show_exif_maker_notes').hide()
    })
})
$(function(){
    $('#toggle_exif_off').click(function(){
        $('#toggle_exif_on').show()
        $('#toggle_exif_off').hide()
        $('#exif_exif, #exif_xmp, #exif_photoshop, #exif_iptc, #exif_jfif, #exif_file, #exif_composite, #exif_icc_profile, #exif_exif_tool, #exif_maker_notes').hide()
        $('#show_exif_exif, #show_exif_xmp, #show_exif_photoshop, #show_exif_iptc, #show_exif_jfif, #show_exif_file, #show_exif_composite, #show_exif_icc_profile, #show_exif_exif_tool, #show_exif_maker_notes').show()
    })
})

function hide_footer(){
    $('#footer').toggle();
}
$(function(){
   $("#histo, #exif_exif, #exif_xmp, #exif_photoshop, #exif_iptc, #exif_exif_tool, #exif_jfif, #exif_file, #exif_maker_notes, #exif_composite, #exif_icc_profile, #toggle_exif_off").hide()
   $("#show_exif_exif, #show_exif_xmp, #show_exif_photoshop, #show_exif_iptc, #show_exif_exif_tool, #show_exif_jfif, #show_exif_file, #show_exif_maker_notes, #show_exif_composite, #show_exif_icc_profile, #toggle_exif_on").show()
});

$(function() {
    $('#show_exif_exif').click(function (){
        $('#exif_exif').show()
        $('#show_exif_exif').hide()
    })
})

$(function() {
    $('#exif_exif').click(function(){
        $('#exif_exif').hide()
        $('#show_exif_exif').show()
    })
})
$(function() {
    $('#show_exif_xmp').click(function (){
        $('#exif_xmp').show()
        $('#show_exif_xmp').hide()
    })
})

$(function() {
    $('#exif_xmp').click(function(){
        $('#exif_xmp').hide()
        $('#show_exif_xmp').show()
    })
})
$(function() {
    $('#show_exif_photoshop').click(function (){
        $('#exif_photoshop').show()
        $('#show_exif_photoshop').hide()
    })
})

$(function() {
    $('#exif_photoshop').click(function(){
        $('#exif_photoshop').hide()
        $('#show_exif_photoshop').show()
    })
})
$(function() {
    $('#show_exif_iptc').click(function (){
        $('#exif_iptc').show()
        $('#show_exif_iptc').hide()
    })
})


$(function() {
    $('#exif_iptc').click(function(){
        $('#exif_iptc').hide()
        $('#show_exif_iptc').show()
    })
})
$(function() {
    $('#show_exif_exif_tool').click(function (){
        $('#exif_exif_tool').show()
        $('#show_exif_exif_tool').hide()
    })
})
$(function() {
    $('#exif_exif_tool').click(function(){
        $('#exif_exif_tool').hide()
        $('#show_exif_exif_tool').show()
    })
})
$(function() {
    $('#show_exif_jfif').click(function (){
        $('#exif_jfif').show()
        $('#show_exif_jfif').hide()
    })
})

$(function() {
    $('#exif_jfif').click(function(){
        $('#exif_jfif').hide()
        $('#show_exif_jfif').show()
    })
})
$(function() {
    $('#show_exif_file').click(function (){
        $('#exif_file').show()
        $('#show_exif_file').hide()
    })
})

$(function() {
    $('#exif_file').click(function(){
        $('#exif_file').hide()
        $('#show_exif_file').show()
    })
})
$(function() {
    $('#show_exif_maker_notes').click(function (){
        $('#exif_maker_notes').show()
        $('#show_exif_maker_notes').hide()
    })
})

$(function() {
    $('#exif_maker_notes').click(function(){
        $('#exif_maker_notes').hide()
        $('#show_exif_maker_notes').show()
    })
})
$(function() {
    $('#show_exif_composite').click(function (){
        $('#exif_composite').show()
        $('#show_exif_composite').hide()
    })
})

$(function() {
    $('#exif_composite').click(function(){
        $('#exif_composite').hide()
        $('#show_exif_composite').show()
    })
})
$(function() {
    $('#show_exif_icc_profile').click(function (){
        $('#exif_icc_profile').show()
        $('#show_exif_icc_profile').hide()
    })
})

$(function() {
    $('#exif_icc_profile').click(function(){
        $('#exif_icc_profile').hide()
        $('#show_exif_icc_profile').show()
    })
})

 $(function() {
   $("#click_histo").click(function () {
      $('#histo').show()
      $('#top_exif').hide()
    });
 });
 
 $(function() {
   $("#histo").click(function () {
      $('#histo').hide()
      $('#top_exif').show()
    });
 });

var sec = 6;   // set the seconds
var min = 00;   // set the minutes

function countDown() {
    if(!isNaN(sec)){
   sec--;
}
  if (sec == -1) {
   sec = 5;
   }
 
if(sec == 0){
    sec = 'smile';
    take_snapshot();
}


  time = sec;

if (document.getElementById) {document.getElementById('counter').innerHTML = time;}

SD=window.setTimeout("countDown();", 1000);
if (sec == 'smile') { 
    sec = "00"; 
    window.clearTimeout(SD);}
}

