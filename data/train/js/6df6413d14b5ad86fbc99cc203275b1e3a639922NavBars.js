/**
 * Created by Richard Treichl on 14.04.2016.
 */
function createNavBars(){
    $("#navBar").jqxNavBar({
        theme: "metrodark",
        height: 40,
        selectedItem: 0
    });
    $("#navBar2").jqxNavBar({
        height: 300,
        width: '100%',
        minimizedHeight: 40,
        minimizeButtonPosition: 'right',
        orientation: 'vertical',
        selectedItem: 0,
        minimized: true,
        theme: "metrodark",
    });
    $("#navBar2").jqxNavBar({ minimizedTitle: 'Home: Overview'});
    $("#navBar2").jqxNavBar('open');
    $("#navBar2").jqxNavBar('close');
    $('#navBar2').on('change', function (event) {
        var index = $("#navBar2").jqxNavBar('getSelectedIndex');
        var text =  $('#navBar2').jqxNavBar('minimizedTitle');
        part = $(event.owner._items[index]).attr("data");
        text = text.split(':');
        text = text[0] + ': ' + event.owner._items[index].innerText;
        $("#navBar2").jqxNavBar({ minimizedTitle: text});
        $('#navBar2').jqxNavBar('close');
    });
    $('#navBar').on('change', function (event) {
        var index = $("#navBar").jqxNavBar('getSelectedIndex');
        var text =  $('#navBar2').jqxNavBar('minimizedTitle');
        text = text.split(':');
        text = event.owner._items[index].innerText + ':' + text[1];
        sensor = event.owner._items[index].innerText;
        $("#navBar2").jqxNavBar({ minimizedTitle: text});
        $.get('/php/getSensorData2.php',
            {
                sensor: event.owner._items[index].innerText,
                data: 'html',
                what: 'data',
            },
            function(data) {
                var nav =$('#navBar2');
                nav.jqxNavBar({minimized: false});
                nav.children().html(data);
                nav.jqxNavBar({minimized: true});
                nav.jqxNavBar('selectAt', 0);
                //nav.html(data);
        });
        createDashBoard();
    });
}

function refreshNavBars() {

}