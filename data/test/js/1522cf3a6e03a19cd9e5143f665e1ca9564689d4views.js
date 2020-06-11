function viewBubble() {
    $("#tabs").show();
    $("input:checkbox").show();
    $("#checkerbox").hide();
    
    $("#selectsort").show();
    $("thead").hide();
    $(".bubble").show();
    $(".table").hide();
}

function viewTable() {
    $("#tabs").show();
    $("input:checkbox").show();
    $("#checkerbox").hide();
    
    $("#selectsort").hide();
    $("thead").show();
    $(".table").show();
    $(".bubble").hide();
    $(".tablesorter").tablesorter();
}

function viewCheckerbox() {
    $("#tabs").hide();
    $("input:checkbox").hide();
    $("#checkerbox").show();
}
